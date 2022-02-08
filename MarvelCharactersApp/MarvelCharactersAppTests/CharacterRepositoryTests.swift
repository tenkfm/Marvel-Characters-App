//
//  CharacterRepositoryTests.swift
//  CharacterRepositoryTests
//
//  Created by Anton Rogachewskyi on 01/02/2022.
//

import XCTest
@testable import MarvelCharactersApp

class CharacterRepositoryTests: XCTestCase {
    var repository: CharacterRepositoryProtocol?

    var coreDataService: CoreDataServiceProtocol?
    var networkService: CharactersNetworkingServiceMock?

    override func setUpWithError() throws {
        let coreDataService = CoreDataServiceMock()
        self.coreDataService = coreDataService
        let networkService = CharactersNetworkingServiceMock()
        self.networkService = networkService

        repository = CharacterRepository(
            coreDataService: coreDataService,
            networkingService: networkService
        )
    }

    func testFetchCharactersFromCache() throws {
        var isLoadedFromCache: Bool?

        let pageInfo = PageInfo(offset: 0, limit: 50, total: 50, count: 50)
        repository?.fetchMoreCharacters(
            currentPageInfo: pageInfo,
            completion: { result in
                switch result {
                case .success(let info):
                    isLoadedFromCache = info.1
                case .failure:
                    XCTFail("Failed fetch characters request")
                }
            }
        )

        XCTAssertNotNil(isLoadedFromCache)
        XCTAssertTrue(isLoadedFromCache ?? false)
    }

    func testFetchCharactersFromNetwork() throws {
        let exp = expectation(description: "Load characters from the network")

        let pageInfo = PageInfo(offset: 0, limit: 50, total: 50, count: 50)
        repository?.fetchMoreCharacters(
            currentPageInfo: pageInfo,
            completion: { result in
                switch result {
                case .success(let info):
                    if !info.1 {

                        exp.fulfill()
                    }
                case .failure:
                    XCTFail("Failed fetch characters request")
                }
            }
        )

        wait(for: [exp], timeout: 4)
    }
}
