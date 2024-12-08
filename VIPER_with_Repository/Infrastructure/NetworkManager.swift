import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

protocol APIClient {
    func get(url: String, completion: @escaping (Result<Data, Error>) -> Void)
}

internal class NetworkManager {
    private let urlSession: URLSessionProtocol
    private let responseValidator: ResponseValidating

    init(urlSession: URLSessionProtocol = URLSession.shared, responseValidator: ResponseValidating) {
        self.urlSession = urlSession
        self.responseValidator = responseValidator
    }
}

extension NetworkManager: APIClient {
    internal func get(
        url: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        urlSession.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let response = response else {
                completion(.failure(NetworkError.noResponse))
                return
            }

            do {
                try self?.responseValidator.validate(response)
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
