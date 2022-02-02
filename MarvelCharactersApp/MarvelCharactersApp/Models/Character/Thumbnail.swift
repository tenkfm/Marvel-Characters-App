import Foundation

struct Thumbnail: Decodable {
    enum Resolution: String {
        case small = "portrait_small"
        case medium = "portrait_medium"
        case xlarge = "portrait_xlarge"
        case fantastic = "portrait_fantastic"
        case uncanny = "portrait_uncanny"
        case incredible = "portrait_incredible"
    }

    let path: String
    let `extension`: String

    func url(of resolution: Resolution) -> String {
        String(format: "%@/%@.%@", path, resolution.rawValue, `extension`)
    }
}
