import XCTest

internal class ResponseValidatorTests: XCTestCase {
    private var validator: ResponseValidating!
    
    override func setUp() {
        super.setUp()
        validator = ResponseValidator()
    }
    
    override func tearDown() {
        validator = nil
        super.tearDown()
    }
}
