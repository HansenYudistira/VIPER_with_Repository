import Foundation

protocol ResponseValidating {
    func validate(_ response: URLResponse) throws
}

internal struct ResponseValidator: ResponseValidating {
    internal func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400:
            throw NetworkError.invalidParameters
        case 404:
            throw NetworkError.invalidURL
        case 400...499:
            throw NetworkError.clientError(statusCode: httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.unknownError
        }
    }
}