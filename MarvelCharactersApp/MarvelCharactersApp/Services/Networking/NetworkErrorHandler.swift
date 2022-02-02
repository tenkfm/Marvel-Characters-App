import Foundation

protocol NetworkErrorHandlerProtocol {
    func isErrorOcured(response: HTTPURLResponse) -> Bool
    func handle(response: HTTPURLResponse, data: Data) -> NetworkingError
}

class NetworkErrorHandler: NetworkErrorHandlerProtocol {
    private let successSuccessCodes = 200...299

    func isErrorOcured(response: HTTPURLResponse) -> Bool {
        !successSuccessCodes.contains(response.statusCode)
    }

    func handle(response: HTTPURLResponse, data: Data) -> NetworkingError {
        if response.statusCode == 401 {
            return .unauthorized(error: decodeMarvelError(data: data))
        }

        return .serverError(error: decodeMarvelError(data: data))
    }
}

private extension NetworkErrorHandler {
    func decodeMarvelError(data: Data) -> MarvelError? {
        let decoder = JSONDecoder()
        return try? decoder.decode(MarvelError.self, from: data)
    }
}
