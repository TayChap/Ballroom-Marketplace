//
//  BallroomBuySellUITests.swift
//  BallroomBuySellUITests
//
//  Created by Taylor Chapman on 2022-11-12.
//

import XCTest

final class BallroomBuySellUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launch()
        
        // login
        app.buttons["addItem"].tap()
        if !app.buttons["loginButton"].exists {
            return
        }
        
        let textField = app.textFields["textField"]
        textField.tap()
        textField.typeText("seller@1.com")
        app.buttons["loginButton"].tap()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - My UI Test Example
    func testExample() throws {
        // start app
        let app = XCUIApplication()
        app.launch()
        
        // execute test
        app.buttons["addItem"].tap()
        
        // validate test
        let notes = app.textViews["textView"]
        XCTAssert(notes.isEnabled)
        XCTAssert(notes.value as? String == "")
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
