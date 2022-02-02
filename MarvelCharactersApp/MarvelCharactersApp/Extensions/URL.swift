import Foundation

extension URL {
    func appending(_ params: [String: String]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems = urlComponents.queryItems ??  []

        let newItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        queryItems.append(contentsOf: newItems)
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
