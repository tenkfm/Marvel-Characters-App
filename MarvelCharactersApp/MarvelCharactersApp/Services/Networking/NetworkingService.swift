import Foundation

protocol NetworkingServiceProtocol {
    func request<T: Decodable>(
        endpoint: Endpoint,
        handlerQueue: DispatchQueue,
        handler: @escaping (Result<T, NetworkingError>) -> Void
    )
}

final class NetworkingService: NetworkingServiceProtocol {
    private let session = URLSession(configuration: .default)
    private let errorHandler: NetworkErrorHandlerProtocol
    private let authorizationHandler: AuthorizationHandler
    
    private(set) var dataTask: URLSessionDataTask?

    init(errorHandler: NetworkErrorHandlerProtocol = NetworkErrorHandler(),
         authorizationHandler: AuthorizationHandler = MarvelAuthorizationHandler(config: Bundle.defaultConfig)
    ) {
        self.errorHandler = errorHandler
        self.authorizationHandler = authorizationHandler
    }

    func request<T: Decodable>(
        endpoint: Endpoint,
        handlerQueue: DispatchQueue = DispatchQueue.main,
        handler: @escaping (Result<T, NetworkingError>) -> Void
    ) {
        var url = endpoint.baseUrl.appendingPathComponent(endpoint.url)
        // Append query parameters
        if let queryParameters = endpoint.queryParameters {
            url = url.appending(queryParameters)
        }

        // Append authorization parameters
        do {
            try url = authorizationHandler.authorizedUrl(url)
        } catch {
            handlerQueue.async { handler(.failure(.authorizationError)) }
            return
        }

        dataTask = session.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            guard let self = self else {
                return
            }

            guard let data = data else {
                handlerQueue.async { handler(.failure(.noDataAvailable)) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                handlerQueue.async { handler(.failure(.unsupportedResponseType)) }
                return
            }

            guard !self.errorHandler.isErrorOcured(response: httpResponse) else {
                handlerQueue.async { handler(.failure(self.errorHandler.handle(response: httpResponse, data: data))) }
                return
            }

            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                handlerQueue.async { handler(.success(object)) }
            } catch {
                handlerQueue.async { handler(.failure(.unknown(error: error))) }
            }
        })
        dataTask?.resume()
    }
}
