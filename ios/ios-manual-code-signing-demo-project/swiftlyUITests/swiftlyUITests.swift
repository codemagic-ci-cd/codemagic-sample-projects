//
//  swiftlyUITests.swift
//  swiftlyUITests
//
//  Created by Kevin Freeman on 12/08/2020.
//  Copyright © 2020 Kevin Freeman. All rights reserved.
//

import XCTest

final class swiftlyUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
            XCUIApplication().launch()
        }
    }
}
