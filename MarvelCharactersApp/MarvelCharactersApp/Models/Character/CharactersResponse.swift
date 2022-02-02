import Foundation

struct CharactersResponse: Decodable {
    let attributionText: String
    let data: CharactersResponseData
}

struct CharactersResponseData: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Character]
}
