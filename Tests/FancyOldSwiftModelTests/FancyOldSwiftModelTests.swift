import XCTest
@testable import FancyOldSwiftModel

final class FancyOldSwiftModelTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FancyOldSwiftModel().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
