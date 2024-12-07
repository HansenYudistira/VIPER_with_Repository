import XCTest
@testable import VIPER_with_Repository
import Foundation
import os

final class MockResponseValidator: ResponseValidating {
    var shouldThrowError = false
    var thrownError: Error = NetworkError.unknownError

    func validate(_ response: URLResponse) throws {
        if shouldThrowError {
            throw thrownError
        }
    }
}

final class URLProtocolStub: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        guard let requestHandler = URLProtocolStub.requestHandler else {
            fatalError("Request handler not set!")
        }
        do {
            let (response, data) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}

}

final class NetworkManagerTests: XCTestCase {
    func makeSUT(
        mockSession: MockURLSession = MockURLSession(),
        mockValidator: MockResponseValidator = MockResponseValidator()
    ) -> NetworkManager {
        return NetworkManager(urlSession: mockSession, responseValidator: mockValidator)
    }

    func testGetDataSuccess() async throws {
        let mockSession = MockURLSession()
        let jsonString = #"""
        {
            "meals": [
                { "idMeal": "1", "strMeal": "Test Meal" }
            ]
        }
        """#

        mockSession.mockData = jsonString.data(using: .utf8)
        XCTAssertNotNil(mockSession.mockData, "Mock data conversion failed")
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let mockResponseValidator = MockResponseValidator()
        let sut = makeSUT(mockSession: mockSession, mockValidator: mockResponseValidator)

        do {
            let data = try await sut.get(url: "https://mockurl.com")
            XCTAssertNotNil(data, "Expected valid data but got nil")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = json as? [String: Any], let meals = dict["meals"] as? [[String: Any]] else {
                XCTFail("Expected JSON response with meals array")
                return
            }
            XCTAssertEqual(meals.first?["strMeal"] as? String, "Test Meal", "Unexpected meal name")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testGetDataFailure() async {
        let mockSession = MockURLSession()
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "mockUrl")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let mockValidator = MockResponseValidator()
        mockValidator.shouldThrowError = true
        mockValidator.thrownError = NetworkError.invalidResponse

        let sut = makeSUT(mockSession: mockSession, mockValidator: mockValidator)

        do {
            _ = try await sut.get(url: "mockUrl")
            XCTFail("Expected an error to be thrown, but the call succeeded")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.invalidURL, "Expected invalidURL error")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let data = mockData, let response = mockResponse else {
            throw NetworkError.invalidResponse
        }
        return (data, response)
    }
}
