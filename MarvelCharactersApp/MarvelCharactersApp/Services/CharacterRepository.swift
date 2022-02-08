import Foundation

protocol CharacterRepositoryProtocol {
    func resetCache()
    func fetchMoreCharacters(
        currentPageInfo: PageInfo,
        completion: @escaping (Result<(CharactersResponse, Bool), NetworkingError>) -> Void
    )
}

final class CharacterRepository {
    private let coreDataService: CoreDataServiceProtocol
    private let networkingService: NetworkingServiceProtocol

    init(
        coreDataService: CoreDataServiceProtocol = CoreDataService(),
        networkingService: NetworkingServiceProtocol = NetworkingService()
    ) {
        self.coreDataService = coreDataService
        self.networkingService = networkingService
    }
}

extension CharacterRepository: CharacterRepositoryProtocol {
    func resetCache() {
        coreDataService.reset()
    }

    private func fetchFromCache() -> [Character] {
        coreDataService.fetchCaracters().map {
            Character(dao: $0)
        }
    }

    func fetchMoreCharacters(
        currentPageInfo: PageInfo,
        completion: @escaping (Result<(CharactersResponse, Bool), NetworkingError>) -> Void
    ) {
        if currentPageInfo.offset == 0 {
            // Load from cache
            let characters = fetchFromCache()
            let response = CharactersResponse(
                attributionText: "Cached data",
                data: CharactersResponseData(
                    offset: 0,
                    limit: characters.count,
                    total: characters.count,
                    count: characters.count,
                    results: characters
                )
            )
            print("📦 Loaded caracters from cache. Page info: \(currentPageInfo)")
            completion(.success((response, true)))
        }

        self.networkingService.request(
            endpoint: .characters(pageInfo: currentPageInfo),
            handlerQueue: .main
        ) { [weak self] (result: Result<CharactersResponse, NetworkingError>) in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                print("🌍 Loaded caracters. Page info: \(currentPageInfo)")
                if currentPageInfo.offset == 0 {
                    self.coreDataService.reset()
                }
                self.coreDataService.append(characters: response.data.results)

                let characters = self.fetchFromCache()
                let response = CharactersResponse(
                    attributionText: "Cached data",
                    data: CharactersResponseData(
                        offset: response.data.offset,
                        limit: response.data.limit,
                        total: response.data.total,
                        count: response.data.count,
                        results: characters
                    )
                )
                completion(.success((response, false)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
