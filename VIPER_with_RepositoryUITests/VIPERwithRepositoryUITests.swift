//
//  VIPER_with_RepositoryUITests.swift
//  VIPER_with_RepositoryUITests
//
//  Created by Hansen Yudistira on 04/12/24.
//

import XCTest

final class VIPERwithRepositoryUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

}
