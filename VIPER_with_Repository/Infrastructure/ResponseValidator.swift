import Foundation

protocol ResponseValidating {
    func validate(_ response: URLResponse) throws
}

internal struct ResponseValidator: ResponseValidating {
    internal func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if httpResponse.statusCode >= 400 {
            throw URLError(.badServerResponse)
        }
    }
}
