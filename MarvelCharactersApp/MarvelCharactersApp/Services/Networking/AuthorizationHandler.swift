import Foundation

protocol AuthorizationHandler {
    func authorizedUrl(_ url: URL) throws -> URL
}

class MarvelAuthorizationHandler: AuthorizationHandler {
    private let config: NSDictionary
    private let apikeyKey = "apikey"
    private let soltKey = "ts"
    private let hashKey = "hash"

    init(config: NSDictionary) {
        self.config = config
    }

    func authorizedUrl(_ url: URL) throws -> URL {
        let uuid = UUID().uuidString
        guard let privateKey = config.object(forKey: "MarvelPrivateKey") as? String,
              let publicKey = config.object(forKey: "MarvelPublicKey") as? String,
              let hash = String(format: "%@%@%@", uuid, privateKey, publicKey).md5() else {
                  throw NetworkingError.authorizationError
              }

        let params: [String: String] = [
            apikeyKey: publicKey,
            soltKey: uuid,
            hashKey: hash
        ]

        return url.appending(params)
    }
}
