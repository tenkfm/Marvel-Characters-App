import Foundation
import UIKit

protocol MainViewModelProtocol: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    /// Remove all items and pagination info, ferch characters
    func fetchCharacters()
    /// Remove all items and pagination info, fetch characters with a filter
    func searchCharacters(name: String)
}

final class MainViewModel: PageViewModel {
    private var characters: [Character] = []
    private var searchString : String?
    private let characterRepository: CharacterRepositoryProtocol

    weak var view: MainViewControllerProtocol?

    init(
        networkingService: NetworkingServiceProtocol = NetworkingService(),
        characterRepository: CharacterRepositoryProtocol = CharacterRepository(),
        limit: Int = 50
    ) {
        self.characterRepository = characterRepository
        super.init(networkingService: networkingService, limit: limit)
    }

    override func loadMoreData() {
        fetchMoreCharacters(usingCache: false)
    }
}

extension MainViewModel: MainViewModelProtocol {
    func fetchCharacters() {
        characterRepository.resetCache()
        resetPageInfo()
        characters = []
        view?.reloadCollection()
        searchString = nil
        fetchMoreCharacters(usingCache: true)
    }

    func searchCharacters(name: String) {
        characters = []
        view?.reloadCollection()
        resetPageInfo()
        fetchMoreCharacters(usingCache: false)
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

private extension MainViewModel {
    func fetchMoreCharacters(usingCache: Bool) {
        dataState = .loading
        view?.update(dataStatus: dataState)
        characterRepository.fetchMoreCharacters(
            currentPageInfo: currentPageInfo
        ) { [weak self] result in

            switch result {
            case .success(let response):
                // Update page info
                self?.currentPageInfo = PageInfo(
                    offset: response.0.data.offset,
                    limit: response.0.data.limit,
                    total: response.0.data.total,
                    count: response.0.data.count
                )
                // Update models
                self?.characters = response.0.data.results
                // Refresh view
                self?.view?.reloadCollection()
                let dataState = response.1 ? NetworkingViewModel.DataState.cached : NetworkingViewModel.DataState.idle
                self?.dataState = dataState
                self?.view?.update(dataStatus: dataState)
            case .failure(let error):
                self?.view?.show(error: error.localizedError)
                self?.dataState = .idle
                self?.view?.update(dataStatus: .idle)
            }
        }
    }
}
