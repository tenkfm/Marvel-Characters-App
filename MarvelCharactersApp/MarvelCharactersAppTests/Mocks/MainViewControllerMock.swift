import Foundation
@testable import MarvelCharactersApp
import XCTest

final class MainViewControllerMock: MainViewControllerProtocol {
    var isCollectionReloaded = false
    var error: String?
    var selectedCharacter: Character?
    var isKeyboardHidden = true
    var dataStatus: NetworkingViewModel.DataState = .none

    var reloadExpectation: XCTestExpectation

    init(reloadExpectation: XCTestExpectation) {
        self.reloadExpectation = reloadExpectation
    }

    func reloadCollection() {
        reloadExpectation.fulfill()
    }

    func show(error: String) {
        self.error = error
    }

    func showComics(for character: Character) {
        selectedCharacter = character
    }

    func hideKeyboard() {
        isKeyboardHidden = true
    }

    func update(dataStatus: NetworkingViewModel.DataState) {
        self.dataStatus = dataStatus
    }
}
