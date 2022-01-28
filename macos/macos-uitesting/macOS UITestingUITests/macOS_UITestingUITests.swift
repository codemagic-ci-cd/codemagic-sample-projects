//
//  macOS_UITestingUITests.swift
//  macOS UITestingUITests
//
//  Created by Rudrank Riyam on 31/10/21.
//

import XCTest

class macOS_UITestingUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // 1
        app.launch()
    }
    
    override func tearDownWithError() throws {
    }
    
    func testShowButtonDisplaysWelcomeLabel() {
      // 2
      let window = app.windows
      
      // 3
      XCTAssertFalse(window.staticTexts["Welcome to Codemagic!"].exists)

      // 4
      let showButton = window.buttons["show"]
      
      // 5
      showButton.click()
      
      // 6
      XCTAssertTrue(window.staticTexts["Welcome to Codemagic!"].exists)
    }
}
