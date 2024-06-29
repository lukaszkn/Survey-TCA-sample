//
//  SurveyQuestionsUITests.swift
//  SurveyUITests
//
//  Created by Lukasz on 29/06/2024.
//
//  Test survey questions screen

import XCTest

final class SurveyQuestionsUITests: XCTestCase {
    
    /// Test if submit button is disabled when no answer
    func testSubmitDisabled() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Start survey"].tap()
        
        let submitButton = app.buttons["Submit"]
        XCTAssertTrue(submitButton.waitForExistence(timeout: 5))
        
        // Submit button should be disabled when there's no answer provided
        XCTAssertFalse(submitButton.isEnabled)
    }
    
    /// Test if submit button is enabled when answer text is entered
    func testSubmitEnabled() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Start survey"].tap()
        
        app.collectionViews.textFields["Type your answer here"].tap()
        app.collectionViews.textFields["Type your answer here"].typeText("Answer 1")
        
        // Submit button should be enabled if answer is provided
        XCTAssertTrue(app.buttons["Submit"].isEnabled)
    }
    
    /// Test if Next toolbar button moves to next question
    func testNextButtonNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Start survey"].tap()
        
        let navigationBar = app.navigationBars["Question 1/10"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5))
        
        navigationBar.buttons["Next"].tap()
        XCTAssertTrue(app.navigationBars["Question 2/10"].waitForExistence(timeout: 5))
    }
    
    /// Test answer submission.
    /// Notification banner should be shown, either success or failure
    func testAnswerSubmission() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Start survey"].tap()
        
        app.collectionViews.textFields["Type your answer here"].tap()
        app.collectionViews.textFields["Type your answer here"].typeText("Answer 1")
        app.buttons["Submit"].tap()
        
        let successNotificationExists = app.staticTexts["Success!"].waitForExistence(timeout: 5)
        let failureNotificationExists = app.staticTexts["Failure...."].waitForExistence(timeout: 5)
        
        XCTAssertTrue(successNotificationExists || failureNotificationExists, "Success or failure notification banner should be present")
    }
}
