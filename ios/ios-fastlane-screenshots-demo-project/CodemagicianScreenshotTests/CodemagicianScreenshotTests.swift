//
//  CodemagicianScreenshotTests.swift
//  CodemagicianScreenshotTests
//
//  Created by Rudrank Riyam on 13/02/22.
//

import XCTest

class CodemagicianScreenshotTests: XCTestCase {
  var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
    setupSnapshot(app)
    app.launch()
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testTakeScreenshots() {
    let scrollView = app.scrollViews.element(boundBy: 0)

    snapshot("01-CICDWithCodemagicScreen")

    scrollView.swipeLeft()

    snapshot("02-AutomatedTestsScreen")

    scrollView.swipeLeft()

    snapshot("03-CLIToolsScreen")

    scrollView.swipeLeft()

    snapshot("04-PostProcessingActionsScreen")

    scrollView.swipeLeft()

    snapshot("05-ContinuousDeliveryScreen")
  }

  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
