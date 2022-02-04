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

    static func showNetwork(
        error: String,
        in viewController: UIViewController,
        handler: @escaping () -> Void
    ) {
        let alertController = UIAlertController(
            title: nil,
            message: error,
            preferredStyle: .alert)

        let okAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil
        )

        let resendAction = UIAlertAction(
            title: "Retry",
            style: .default
        ) { _ in
            handler()
        }

        alertController.addAction(okAction)
        alertController.addAction(resendAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
