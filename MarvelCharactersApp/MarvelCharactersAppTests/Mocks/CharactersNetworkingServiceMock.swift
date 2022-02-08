import Foundation
@testable import MarvelCharactersApp

final class CharactersNetworkingServiceMock: NetworkingServiceProtocol {
    func request<T>(
        endpoint: Endpoint,
        handlerQueue: DispatchQueue,
        handler: @escaping (Result<T, NetworkingError>) -> Void
    ) where T : Decodable {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let jsonData: Data
            guard let filePath = Bundle(for: type(of: self)).path(forResource: "CharactersResponse", ofType: "json"),
                  let fileUrl = URL(string: filePath) else {
                      handler(.failure(.invalidUrl))
                      return
                  }

            do {
                jsonData = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: jsonData)
                handlerQueue.async { handler(.success(object)) }
            } catch {
                print(error)
                handlerQueue.async { handler(.failure(.unknown(error: error))) }
            }
        }
    }
}
