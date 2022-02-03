import Foundation
import UIKit

protocol ComicsViewModelProtocol: UITableViewDataSource, UITableViewDelegate {
    /// Load and update title view
    func loadViewTitle()
    /// Remove all cached items and pagination info, ferch comics
    func fetchComics()
}

final class ComicsViewModel: PageigationViewModel {
    private let character: Character
    private var comics: [Comics] = []

    weak var view: ComicsViewControllerProtocol?

    init(
        character: Character,
        networkingService: NetworkingServiceProtocol = NetworkingService(),
        limit: Int = 50
    ) {
        self.character = character
        super.init(networkingService: networkingService, limit: limit)
    }

    override func loadMoreData() {
        fetchMoreComics()
    }
}

extension ComicsViewModel: ComicsViewModelProtocol {
    func loadViewTitle() {
        view?.set(title: character.name)
    }

    func fetchComics() {
        resetPageInfo()
        fetchMoreComics()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ComicsTableViewCell", for: indexPath
        ) as? ComicsTableViewCell else {
            return UITableViewCell()
        }

        let comics = comics[indexPath.row]
        let viewModel = ComicsTableViewCellModel(
            coverImageUrl: comics.thumbnail.url(of: .small),
            title: comics.title,
            description: comics.description
        )

        cell.apply(viewModel: viewModel)
        return cell
    }
}

private extension ComicsViewModel {
    func fetchMoreComics() {
        let endpoint = Endpoint.comics(characterId: character.id, pageInfo: currentPageInfo)
        print("🌍 Fetch caracters. Page info: \(currentPageInfo)")

        dataState = .loading
        self.networkingService.request(
            endpoint: endpoint,
            handlerQueue: .main
        ) { [unowned self] (result: Result<ComicsResponse, NetworkingError>) in
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
                self.comics.append(contentsOf: response.data.results)
                // Refresh view
                self.view?.reloadTableView()
                dataState = .idle
            case .failure(let error):
                self.view?.show(error: error.localizedError)
                dataState = .idle
            }
        }
    }
}
