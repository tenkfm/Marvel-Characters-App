import Foundation

protocol NetworkingServiceProtocol {

}

final class NetworkingService: NetworkingServiceProtocol {
    private let config = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)!
    private let defaultSession = URLSession(configuration: .default)

    var dataTask: URLSessionDataTask?

}
