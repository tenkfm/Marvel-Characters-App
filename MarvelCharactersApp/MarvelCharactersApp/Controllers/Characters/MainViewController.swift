import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func reloadCollection()
    func show(error: String)
    func showComics(for character: Character)
    func hideKeyboard()
}

final class MainViewController: UIViewController {
    let searchTextField = UITextField()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    lazy var flowLayout: UICollectionViewLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        return flowLayout
    }()

    private var comicsViewControllerFactory: ComicsViewControllerFactoryProtocol
    private var viewModel: MainViewModelProtocol

    init(
        viewModel: MainViewModelProtocol,
        comicsViewControllerFactory: ComicsViewControllerFactoryProtocol = ComicsViewControllerFactory()
    ) {
        self.viewModel = viewModel
        self.comicsViewControllerFactory = comicsViewControllerFactory
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
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func show(error: String) {
        UIAlertController.show(error: error, in: self)
    }

    func reloadCollection() {
        collectionView.reloadData()
    }

    func showComics(for character: Character) {
        let viewController = comicsViewControllerFactory.create(character: character)
        navigationController?.pushViewController(viewController, animated: true)
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
        title = "Marvel characters"
        searchTextField.placeholder = "Search ..."
        searchTextField.returnKeyType = .search
        searchTextField.borderStyle = .roundedRect
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = view.backgroundColor
    }

    func configureSubviews() {
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
    }

    func configureDependencies() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        searchTextField.delegate = viewModel
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCollectionViewCell")
    }

    func configureConstraints() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),

            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
