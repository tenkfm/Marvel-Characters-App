import Foundation
import CoreData

struct Character: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail

    init(dao: CharacterDAO) {
        self.id = Int(dao.id)
        self.name = dao.name ?? ""
        self.description = dao.text ?? ""
        self.thumbnail = Thumbnail(
            path: dao.thumbnail?.path ?? "",
            extension: dao.thumbnail?.ext ?? ""
        )
    }

    func dao(for managedObjectContext: NSManagedObjectContext) -> CharacterDAO {
        let dao = CharacterDAO(context: managedObjectContext)
        dao.id = Int64(id)
        dao.name = name
        dao.text = description
        dao.thumbnail = thumbnail.dao(for: managedObjectContext)
        return dao
    }
}
