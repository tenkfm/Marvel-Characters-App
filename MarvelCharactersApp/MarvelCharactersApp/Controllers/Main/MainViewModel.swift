import Foundation
import UIKit

protocol MainViewModelProtocol: UICollectionViewDataSource, UICollectionViewDelegate {

}

final class MainViewModel: NSObject {
    private var data: [String] = ["sdf", "dsfsd", "dfsfds"]

    weak var view: MainViewControllerProtocol?
}

extension MainViewModel: MainViewModelProtocol {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
