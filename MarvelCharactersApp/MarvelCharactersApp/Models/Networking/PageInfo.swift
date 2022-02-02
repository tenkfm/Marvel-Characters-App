import Foundation

struct PageInfo {
    var offset: Int
    var limit: Int
    var total: Int?
    var count: Int?

    init(offset: Int = 0, limit: Int = 50, total: Int? = nil, count: Int? = nil) {
        self.offset = offset
        self.limit = limit
        self.total = total
        self.count = count
    }

    var isLast: Bool {
        (total ?? 0) <= offset + limit
    }
}
