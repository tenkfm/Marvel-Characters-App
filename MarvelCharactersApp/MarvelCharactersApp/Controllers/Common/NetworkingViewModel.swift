import Foundation

class NetworkingViewModel: NSObject {
    enum DataState {
        case none
        case idle
        case loading
        case caching
    }
    internal var networkingService: NetworkingServiceProtocol
    internal var dataState: DataState = .none

    init(networkingService: NetworkingServiceProtocol) {
        self.networkingService = networkingService
    }
}
