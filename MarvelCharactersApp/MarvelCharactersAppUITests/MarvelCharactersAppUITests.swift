//
//  MarvelCharactersAppUITests.swift
//  MarvelCharactersAppUITests
//
//  Created by Anton Rogachewskyi on 01/02/2022.
//

import XCTest

class MarvelCharactersAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testShouldLoadCharactersDataImmediately() throws {
        let app = XCUIApplication()
        app.launch()

        let exp = expectation(description: "Wait for data load")

        let collectionView = app.collectionViews["CharactersCollectionView"]

        waitForExpectations(timeout: 5) { error in
            XCTAssertEqual(collectionView.cells.count, 50)
        }
    }
}
