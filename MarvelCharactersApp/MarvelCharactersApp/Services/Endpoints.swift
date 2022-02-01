import Foundation

protocol EndpointsProtocol {
    var url: String { get }
}

enum Endpoints {
    case characters
    case comics(characterId: String)
}

extension Endpoints: EndpointsProtocol {
    var url: String {
        switch self {
        case .characters:
            return "/v1/public/characters"
        case .comics(let characterId):
            return "/v1/public/characters/\(characterId)/comics"
        }
    }

}
