import Foundation
import UIKit

protocol ComicsViewControllerFactoryProtocol {
    func create(character: Character) -> UIViewController
}

final class ComicsViewControllerFactory: ComicsViewControllerFactoryProtocol {
    func create(character: Character) -> UIViewController {
        let viewModel = ComicsViewModel(character: character)
        let viewController = ComicsViewController(viewModel: viewModel)
        viewModel.view = viewController
        return viewController
    }
}
