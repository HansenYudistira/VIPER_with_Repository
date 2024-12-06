//
//  VIPER_with_RepositoryUITestsLaunchTests.swift
//  VIPER_with_RepositoryUITests
//
//  Created by Hansen Yudistira on 04/12/24.
//

import XCTest

final class VIPERwithRepositoryUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

}
