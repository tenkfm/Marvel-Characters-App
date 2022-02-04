import CoreData
import UIKit

protocol CoreDataServiceProtocol {
    /// Fetch characters from the database
    func fetchCaracters() -> [CharacterDAO]
    /// Append characters to the data base
    func append(characters: [Character])
    /// Reset database - Erase all data
    func reset()
}

final class CoreDataService {
    private var managedObjectContext: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}

extension CoreDataService: CoreDataServiceProtocol {
    func fetchCaracters() -> [CharacterDAO] {
        var data: [CharacterDAO]
        let fetchRequest = CharacterDAO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            data = try managedObjectContext.fetch(fetchRequest)
        } catch {
            data = []
        }
        return data
    }

    func append(characters: [Character]) {
        let _: [CharacterDAO] = characters.map ({
            $0.dao(for: managedObjectContext)
        })

        do {
            try managedObjectContext.save()
            print("📦 Caracters cache updated")
        } catch let error as NSError {
            print("⛔️ Failed to save new character \(error): \(error.userInfo)")
        }
    }

    func reset() {
        let characters = fetchCaracters()
        characters.forEach {
            managedObjectContext.delete($0)
        }
        print("📦 Reset cache done")
    }
}
