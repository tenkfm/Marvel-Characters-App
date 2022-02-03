import Foundation

struct Comics: Decodable {
    let id: Int
    let title: String
    let description: String?
    let thumbnail: Thumbnail
}
