import Foundation
import UIKit

protocol MainViewControllerFactoryProtocol {
    func create() -> UIViewController
}

final class MainViewControllerFactory: MainViewControllerFactoryProtocol {
    func create() -> UIViewController {
        let viewModel = MainViewModel()
        let viewController = MainViewController(viewModel: viewModel)
        viewModel.view = viewController
        return viewController
    }
}
