import Foundation

protocol EndpointProtocol {
    var baseUrl: URL { get }
    var url: String { get }
}

enum Endpoint {
    case characters
    case comics(characterId: String)
}

extension Endpoint: EndpointProtocol {
    var baseUrl: URL {
        URL(string: "https://gateway.marvel.com:443/")!
    }

    var url: String {
        switch self {
        case .characters:
            return "/v1/public/characters"
        case .comics(let characterId):
            return "/v1/public/characters/\(characterId)/comics"
        }
    }
}
