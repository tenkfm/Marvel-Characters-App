import Foundation

struct Thumbnail: Decodable {
    enum Resolution: String {
        case small = "portrait_small" // 50x75px
        case medium = "portrait_medium" // 100x150px
        case xlarge = "portrait_xlarge" // 150x225px
        case fantastic = "portrait_fantastic" // 168x252px
        case uncanny = "portrait_uncanny" // 300x450px
        case incredible = "portrait_incredible" // 216x324px
    }

    let path: String
    let `extension`: String

    func url(of resolution: Resolution) -> String {
        String(format: "%@/%@.%@", path, resolution.rawValue, `extension`)
    }
}
