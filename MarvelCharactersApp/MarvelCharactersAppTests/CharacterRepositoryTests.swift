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

    func testFetch50CharactersFromNetwork() throws {
        let exp = expectation(description: "Load characters from the network")

        let pageInfo = PageInfo(offset: 0, limit: 50, total: 50, count: 50)
        repository?.fetchMoreCharacters(
            currentPageInfo: pageInfo,
            completion: { result in
                switch result {
                case .success(let info):
                    if !info.1 {
                        XCTAssertEqual(info.0.data.results.count, 50)
                        exp.fulfill()
                    }
                case .failure:
                    XCTFail("Failed fetch characters request")
                }
            }
        )

        wait(for: [exp], timeout: 5)
    }

    func testFetchMoreCharactersOnSequentRequests() throws {
        let firstRequestExp = expectation(description: "Load characters from the network 1st time")
        let secondRequestExp = expectation(description: "Load characters from the network 2nd time")

        let pageInfo = PageInfo(offset: 0, limit: 50, total: 50, count: 50)
        repository?.fetchMoreCharacters(
            currentPageInfo: pageInfo,
            completion: { result in
                switch result {
                case .success(let info):
                    if !info.1 {
                        XCTAssertEqual(info.0.data.results.count, 50)
                        firstRequestExp.fulfill()
                        let pageInfo = PageInfo(
                            offset: info.0.data.limit,
                            limit: info.0.data.limit,
                            total: info.0.data.total,
                            count: info.0.data.count
                        )

                        self.repository?.fetchMoreCharacters(
                            currentPageInfo: pageInfo,
                            completion: { result in
                                switch result {
                                case .success(let info):
                                    XCTAssertEqual(info.0.data.results.count, 100)
                                    secondRequestExp.fulfill()
                                case .failure:
                                    XCTFail("Failed fetch characters request")
                                }
                            }
                        )
                    }
                case .failure:
                    XCTFail("Failed fetch characters request")
                }
            }
        )
        wait(for: [firstRequestExp, secondRequestExp], timeout: 10)
    }
}
