//
//  SurveyQuestionsFeatureTests.swift
//  SurveyTests
//
//  Created by Lukasz on 29/06/2024.
//
//  Test survey questions feature

import ComposableArchitecture
import XCTest
@testable import Survey

@MainActor
final class SurveyQuestionsFeatureTests: XCTestCase {
    
    private var store: TestStore<SurveyQuestionsFeature.State, SurveyQuestionsFeature.Action>?
    
    override func setUp() {
        self.store = TestStore(initialState: SurveyQuestionsFeature.State()) {
            SurveyQuestionsFeature()
        } withDependencies: {
            $0.surveyQuestionsAPIService = .previewValue // use mock data
        }
    }
    
    /// Test fetching questions
    func testFetchingQuestions() async {
        guard let store else { return }
        
        // Send fetch question action
        await store.send(.fetchQuestions) {
            $0.isPerformingNetworkCall = true // progress indicator should be shown
        }
        
        // We should receive questions fetched action with 3 questions
        await store.receive(\.questionsFetched, timeout: .seconds(1)) {
            $0.isPerformingNetworkCall = false
            $0.questions = [
                Question(id: 1, question: "Question 1"),
                Question(id: 2, question: "Question 2"),
                Question(id: 3, question: "Question 3")
            ]
        }
    }
    
    /// Test next toolbar button navigation tap
    func testNextQuestionNavigation() async {
        guard let store else { return }
        store.exhaustivity = .off // don't assert everything in new state
        
        await store.send(.nextButtonTapped) {
            $0.currentQuestionIndex = 0 // current question index should be 0 even if next button was tapped cause there are no questions loaded yet
        }
        
        await store.send(.fetchQuestions)
        
        await store.send(.nextButtonTapped) {
            $0.currentQuestionIndex = 1
        }
    }
    
    /// Test previous toolbar button navigation tap
    func testPreviousQuestionNavigation() async {
        guard let store else { return }
        store.exhaustivity = .off // don't assert everything in new state
        
        await store.send(.previousButtonTapped) {
            $0.currentQuestionIndex = 0 // current question index should be 0
        }
        
        await store.send(.fetchQuestions) // fetch mock questions
        await store.send(.nextButtonTapped) // move to the next question
        
        await store.send(.previousButtonTapped) {
            $0.currentQuestionIndex = 0 // current question index should be 0 as flow returned to first question
        }
    }
    
    /// Test submission of answer that has succedded
    func testAnswerSubmissionSuccess() async {
        guard let store else { return }
        
        let answer = Answer(id: 1, answer: "answer")
        await store.send(.submitButtonTapped(answer)) {
            $0.isPerformingNetworkCall = true
        }
        
        await store.receive(\.answerSubmittedSuccessfully) {
            $0.isPerformingNetworkCall = false
            $0.isShowingSuccessMessage = true // should show success notification
            $0.answersSubmitted = [answer]
        }
    }
    
    /// Test submission of answer that is failing
    func testAnswerSubmissionFailure() async {
        let store = TestStore(initialState: SurveyQuestionsFeature.State()) {
            SurveyQuestionsFeature()
        } withDependencies: {
            $0.surveyQuestionsAPIService = .testValue // use failing service
        }
        
        let answer = Answer(id: 1, answer: "answer")
        await store.send(.submitButtonTapped(answer)) {
            $0.isPerformingNetworkCall = true
        }
        
        await store.receive(\.answerSubmittedFailure) {
            $0.isPerformingNetworkCall = false
            $0.isShowingFailureMessage = true // should show failure notification
            $0.answerToRetry = answer
        }
    }
}
