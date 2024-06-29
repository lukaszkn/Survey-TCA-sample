//
//  ServiceTests.swift
//  SurveyTests
//
//  Created by Lukasz on 29/06/2024.
//
//  Test survey questions service

import ComposableArchitecture
import XCTest
@testable import Survey

@MainActor
final class ServiceTests: XCTestCase {
    
    /// Test fetching questions for preview
    func testFetchQuestionsForPreview() async {
        do {
            let expected = try await SurveyQuestionsService.previewValue.fetchQuestions()
            XCTAssert(expected.count == 3, "There should be 3 preview questions")
        } catch {
            XCTFail("Fetching preview questions failed");
        }
    }
    
    /// Test questions content for preview
    func testFetchQuestionsContentForPreview() async {
        do {
            let questions = try await SurveyQuestionsService.previewValue.fetchQuestions()
            
            let question = questions.first
            
            XCTAssert(question!.id > 0, "Question identifier should be greater than 0")
            XCTAssert(question!.question.count > 0, "Question text should not be empty")
        } catch {
            XCTFail("Fetching preview questions failed");
        }
    }
    
    /// Test fetching questions for live environment
    func testFetchQuestionsForLive() async {
        do {
            let expected = try await SurveyQuestionsService.liveValue.fetchQuestions()
            XCTAssert(expected.count >= 1, "There should at least 1 question")
        } catch {
            XCTFail("Fetching live questions failed");
        }
    }
    
    /// Test live questions content
    func testFetchQuestionsContentForLive() async {
        do {
            let questions = try await SurveyQuestionsService.liveValue.fetchQuestions()
            
            let question = questions.first
            
            XCTAssert(question!.question.count > 0, "Question text should not be empty")
        } catch {
            XCTFail("Fetching live questions failed");
        }
    }
    
    /// Test submitting answer to live API
    func testAnswerSubmitForLive() async {
        do {
            try await SurveyQuestionsService.liveValue.submitAnswer(Answer(id: 1, answer: "Answer text"))
            XCTAssertTrue(true, "Submitting answer should be successful")
        } catch {
            XCTFail("Submitting answer has failed");
        }
    }
    
    /// Test failing service
    func testFailingFetchQuestionsService() async {
        do {
            _ = try await SurveyQuestionsService.testValue.fetchQuestions()
            XCTFail("This service should have failed fetching questions");
        } catch {
            XCTAssert(!error.localizedDescription.isEmpty)
        }
    }

}
