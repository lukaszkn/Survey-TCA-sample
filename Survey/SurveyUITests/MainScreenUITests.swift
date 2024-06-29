//
//  SurveyUITests.swift
//  SurveyUITests
//
//  Created by Lukasz on 27/06/2024.
//
//  Test main screen and master/details navigation

import XCTest

final class MainScreenUITests: XCTestCase {

    /// Test Start survey screen
    func testMainScreenUI() throws {
        let app = XCUIApplication()
        app.launch()

        // Check if Start survey button exists on main screen at all
        XCTAssert(app.buttons["Start survey"].waitForExistence(timeout: 2))
    }
    
    /// Test start screen to survey questions navigation.
    /// Survey questions should have 0 answers submitted
    func testMainToQuestionsNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Start survey"].tap()
        XCTAssert(app.staticTexts["Questions submitted: 0"].waitForExistence(timeout: 10))
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
