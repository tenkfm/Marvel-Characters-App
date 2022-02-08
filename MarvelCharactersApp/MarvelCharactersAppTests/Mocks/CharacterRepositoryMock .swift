import Foundation
@testable import MarvelCharactersApp
import CoreData

final class CoreDataServiceMock: CoreDataServiceProtocol {
    var cachedCharacters: [CharacterDAO] = []

    func fetchCaracters() -> [CharacterDAO] {
        cachedCharacters
    }

    func append(characters: [Character]) {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        let characterDAOs: [CharacterDAO] = characters.map ({
            $0.dao(for: managedObjectContext)
        })
        cachedCharacters.append(contentsOf: characterDAOs)
    }

    func reset() {
        cachedCharacters = []
    }
}
