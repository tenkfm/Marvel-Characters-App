import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func show(error: String)
}

class MainViewController: UIViewController {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    lazy var flowLayout = UICollectionViewLayout()

    private var viewModel: MainViewModelProtocol

    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchCharacters()
    }
}

extension MainViewController: MainViewControllerProtocol {
    func show(error: String) {
        UIAlertController.show(error: error, in: self)
    }
}

private extension MainViewController {
    func setupView() {
        configureStyling()
        configureSubviews()
        configureConstraints()
        configureDependencies()
    }

    func configureStyling() {
        view.backgroundColor = .white
    }

    func configureSubviews() {
        view.addSubview(collectionView)
    }

    func configureDependencies() {
        collectionView.dataSource = viewModel
    }

    func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
