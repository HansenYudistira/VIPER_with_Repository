import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol APIClient {
    func get(url: String) async throws -> Data
}

internal class NetworkManager: APIClient {
    private let urlSession: URLSessionProtocol
    private let responseValidator: ResponseValidating

    init(urlSession: URLSessionProtocol = URLSession.shared, responseValidator: ResponseValidating) {
        self.urlSession = urlSession
        self.responseValidator = responseValidator
    }

    internal func get(url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        try responseValidator.validate(response)
        return data
    }
}
