import Foundation
import UIKit

protocol MainViewModelProtocol: UICollectionViewDataSource, UICollectionViewDelegate {
    func fetchCharacters()
}

final class MainViewModel: NSObject {
    private var networkingService: NetworkingServiceProtocol
    private var data: [String] = ["sdf", "dsfsd", "dfsfds"]

    weak var view: MainViewControllerProtocol?

    init(networkingService: NetworkingServiceProtocol = NetworkingService()) {
        self.networkingService = networkingService
    }
}

extension MainViewModel: MainViewModelProtocol {
    func fetchCharacters() {
        self.networkingService.request(endpoint: .characters, handlerQueue: .main) { (result: Result<CharactersResponse, NetworkingError>) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                self.view?.show(error: error.localizedError)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
