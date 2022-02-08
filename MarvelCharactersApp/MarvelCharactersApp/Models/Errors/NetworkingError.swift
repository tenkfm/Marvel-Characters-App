import Foundation

enum NetworkingError: Error {
    case invalidUrl
    case noDataAvailable
    case unsupportedResponseType
    case unauthorized(error: MarvelError?)
    case serverError(error: MarvelError?)
    case authorizationError
    case unknown(error: Error)

    var localizedError: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .noDataAvailable:
            return "No data available"
        case .unsupportedResponseType:
            return "Unsupported response type"
        case .unauthorized(let error):
            return error?.message ?? "Unauthorized"
        case .serverError(let error):
            return error?.message ?? "Server error"
        case .authorizationError:
            return "Authorization error"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
