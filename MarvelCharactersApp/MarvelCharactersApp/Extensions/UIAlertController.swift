import UIKit

extension UIAlertController {
    static func show(
        title: String? = nil,
        error: String,
        in viewController: UIViewController
    ) {
        let alertController = UIAlertController(
            title: title,
            message: error,
            preferredStyle: .alert)

        let okAction = UIAlertAction(
            title: NSLocalizedString("OK", comment: "Limit alert button OK"),
            style: .cancel,
            handler: nil
        )
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
