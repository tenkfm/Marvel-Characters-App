import Foundation
import UIKit

protocol MainViewModelProtocol: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    /// Remove all cached items and pagination info, ferch characters
    func fetchCharacters()
    /// Remove all cached items and pagination info, fetch characters with a filter
    func searchCharacters(name: String)
}

final class MainViewModel: NSObject {
    enum DataState {
        case none
        case idle
        case loading
        case caching
    }
    private var networkingService: NetworkingServiceProtocol
    private var characters: [Character] = []
    private var currentPageInfo: PageInfo
    private var dataState: DataState = .none
    private var searchString : String?

    weak var view: MainViewControllerProtocol?

    init(networkingService: NetworkingServiceProtocol = NetworkingService(), limit: Int = 50) {
        self.networkingService = networkingService
        self.currentPageInfo = PageInfo()
    }
}

extension MainViewModel: MainViewModelProtocol {
    func fetchCharacters() {
        self.currentPageInfo = PageInfo()
        characters = []
        view?.reloadCollection()
        searchString = nil
        fetchMoreCharacters()
    }

    func searchCharacters(name: String) {
        characters = []
        view?.reloadCollection()
        currentPageInfo = PageInfo()
        fetchMoreCharacters()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath
              ) as? CharacterCollectionViewCell else {
                  return UICollectionViewCell()
              }

        let character = characters[indexPath.row]

        let viewModel = CharacterCollectionViewModel(
            coverImageUrl: character.thumbnail.url(of: .xlarge),
            title: character.name,
            description: character.description
        )

        cell.apply(viewModel: viewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 2.0
        let ratio = 1.5
        return CGSize(width: size, height: size * ratio)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        view?.showComics(for:character)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchString = textField.text else { return true }
        let trimmedSearchString = searchString.trimmingCharacters(in: .whitespaces)
        self.searchString = trimmedSearchString
        view?.hideKeyboard()

        guard !trimmedSearchString.isEmpty else {
            fetchCharacters()
            return true
        }

        searchCharacters(name: trimmedSearchString)
        return true
    }
}

extension MainViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        guard contentHeight > 0 else { return }

        if offsetY > contentHeight - scrollView.frame.size.height && dataState != .loading && !currentPageInfo.isLast {
            currentPageInfo.offset += currentPageInfo.limit
            fetchMoreCharacters()
        }
    }
}

private extension MainViewModel {
    func fetchMoreCharacters() {
        var endpoint: Endpoint
        if let searchString = self.searchString {
            endpoint = .searchCaracter(name: searchString, pageInfo: currentPageInfo)
            print("🌍 Search caracters. Page info: \(currentPageInfo)")
        } else {
            endpoint = .characters(pageInfo: currentPageInfo)
            print("🌍 Search caracters. Page info: \(currentPageInfo)")
        }

        dataState = .loading
        self.networkingService.request(
            endpoint: endpoint,
            handlerQueue: .main
        ) { [unowned self] (result: Result<CharactersResponse, NetworkingError>) in
            switch result {
            case .success(let response):
                // Update page info
                self.currentPageInfo = PageInfo(
                    offset: response.data.offset,
                    limit: response.data.limit,
                    total: response.data.total,
                    count: response.data.count
                )
                // Update models
                self.characters.append(contentsOf: response.data.results)
                // Refresh view
                self.view?.reloadCollection()
                dataState = .idle
            case .failure(let error):
                self.view?.show(error: error.localizedError)
                dataState = .idle
            }
        }
    }
}