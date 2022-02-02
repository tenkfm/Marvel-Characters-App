import Foundation

protocol EndpointProtocol {
    var baseUrl: URL { get }
    var url: String { get }
    var queryParameters: [String: String]? { get }
}

enum Endpoint {
    case characters(pageInfo: PageInfo)
    case searchCaracter(name: String, pageInfo: PageInfo)
    case comics(characterId: String)
}

extension Endpoint: EndpointProtocol {
    var baseUrl: URL {
        URL(string: "https://gateway.marvel.com:443/")!
    }

    var url: String {
        switch self {
        case .characters, .searchCaracter:
            return "/v1/public/characters"
        case .comics(let characterId):
            return "/v1/public/characters/\(characterId)/comics"
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .characters(let pageInfo):
            return [
                "offset": "\(pageInfo.offset)",
                "limit": "\(pageInfo.limit)"
            ]
        case .searchCaracter(let name, let pageInfo):
            return [
                "nameStartsWith": name,
                "offset": "\(pageInfo.offset)",
                "limit": "\(pageInfo.limit)"
            ]
        default:
            return nil
        }
    }
}
