import Foundation

struct ComicsResponse: Decodable {
    let attributionText: String
    let data: ComicsResponseData
}

struct ComicsResponseData: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Comics]
}
