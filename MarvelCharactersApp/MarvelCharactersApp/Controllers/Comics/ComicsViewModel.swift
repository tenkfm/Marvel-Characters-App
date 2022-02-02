import Foundation
import UIKit

protocol ComicsViewModelProtocol: UITableViewDataSource, UITableViewDelegate {
    func loadViewTitle()
}

final class ComicsViewModel: NSObject {
    private let character: Character

    weak var view: ComicsViewControllerProtocol?

    init(character: Character) {
        self.character = character
    }
}

extension ComicsViewModel: ComicsViewModelProtocol {
    func loadViewTitle() {
        view?.set(title: character.name)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
