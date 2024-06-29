//
//  SurveyTests.swift
//  SurveyTests
//
//  Created by Lukasz on 27/06/2024.
//
//  This is for testing main app feature

import ComposableArchitecture
import XCTest
@testable import Survey

@MainActor
final class AppFeatureTests: XCTestCase {

    /// Test start screen to questions screen navigation
    func testMasterDetailsNavigation() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        /// It is expected that tapping on start button sets destination as survey questions screen
        /// SurveyQuestionsFeature state should be in its initial state
        await store.send(.mainView(.startButtonTapped)) {
            $0.destination = .surveyQuestions(
                SurveyQuestionsFeature.State(
                    isPerformingNetworkCall: false,
                    isShowingSuccessMessage: false,
                    isShowingFailureMessage: false,
                    questions: [], answersSubmitted: [], answerToRetry: nil,
                    currentQuestionIndex: 0)
            )
        }
    }

}
