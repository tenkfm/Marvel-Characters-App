import Foundation

class NetworkingViewModel: NSObject {
    enum DataState {
        case none
        case idle
        case loading
        case cached

        var description: String {
            switch self {
            case .idle:
                return ""
            case .cached:
                return "Cache"
            case .loading:
                return "Loading..."
            case .none:
                return "No data"
            }
        }
    }
    internal var networkingService: NetworkingServiceProtocol
    internal var dataState: DataState = .none

    init(networkingService: NetworkingServiceProtocol) {
        self.networkingService = networkingService
    }
}
