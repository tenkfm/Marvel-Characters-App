import UIKit

protocol ComicsViewControllerProtocol: AnyObject {
    func reloadCollection()
    func show(error: String)
    func set(title: String)
}

final class ComicsViewController: UIViewController {
    let tableView = UITableView()

    private var viewModel: ComicsViewModelProtocol

    init(viewModel: ComicsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadViewTitle()
    }
}

extension ComicsViewController: ComicsViewControllerProtocol {
    func show(error: String) {
        UIAlertController.show(error: error, in: self)
    }

    func reloadCollection() {
        tableView.reloadData()
    }

    func set(title: String) {
        self.title = title
    }
}

private extension ComicsViewController {
    func setupView() {
        configureStyling()
        configureSubviews()
        configureConstraints()
        configureDependencies()
    }

    func configureStyling() {
        tableView.backgroundColor = view.backgroundColor
    }

    func configureSubviews() {
        view.addSubview(tableView)
    }

    func configureDependencies() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }

    func configureConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
