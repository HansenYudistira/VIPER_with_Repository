import Foundation

protocol APIClient {
    func get<T: Codable>(url: URL) async throws -> T
}

internal class NetworkManager: APIClient {
    private let urlSession: URLSession
    private let responseValidator: ResponseValidating

    init(urlSession: URLSession = .shared, responseValidator: ResponseValidating) {
        self.urlSession = urlSession
        self.responseValidator = responseValidator
    }

    internal func get<T: Codable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        try responseValidator.validate(response)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
