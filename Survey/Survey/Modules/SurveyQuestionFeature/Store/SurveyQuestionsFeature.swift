//
//  SurveyQuestionFeature.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//
//  This is reducer for survey questions screen

import ComposableArchitecture

@Reducer
struct SurveyQuestionsFeature {
    @Dependency(\.surveyQuestionsAPIService) var surveyQuestionsAPIService
    
    @ObservableState
    struct State: Equatable {
        /// Is showing progress view when loading questions or submitting answer
        var isPerformingNetworkCall = false
        
        /// Is showing submission success message
        var isShowingSuccessMessage = false
        
        /// Is showing submission failure message
        var isShowingFailureMessage = false
        
        /// This hold questions populated from API
        var questions: [Question] = []
        
        /// This holds answers successfully submitted to the API
        var answersSubmitted: [Answer] = []
        
        /// This keeps answer to retry
        var answerToRetry: Answer?
        
        /// Current question index in questions list
        var currentQuestionIndex = 0
        
        /// Return current question from the list
        var currentQuestion: Question? {
            return currentQuestionIndex < questions.count ? questions[currentQuestionIndex] : nil
        }
        
        var currentAnswer: Answer? {
            answersSubmitted.first(where: { $0.id == questions[currentQuestionIndex].id })
        }
        
        static func == (lhs: SurveyQuestionsFeature.State, rhs: SurveyQuestionsFeature.State) -> Bool {
            lhs.isPerformingNetworkCall == rhs.isPerformingNetworkCall && lhs.questions.count == rhs.questions.count
        }
    }
    
    enum Action {
        /// Start fetching questions from the api
        case fetchQuestions
        
        /// Fetching questions has finished
        case questionsFetched([Question])
        
        /// Previous toolbar button has been tapped
        case previousButtonTapped
        /// Next toolbar button has been tapped
        case nextButtonTapped
        
        /// Submit button has been tapped, action contains newly created answer
        case submitButtonTapped(Answer)
        /// Retry button has been tapped
        case retryButtonTapped
        
        /// Answer has been submitted successfully, action contains submitted answer
        case answerSubmittedSuccessfully(Answer)
        /// Answer has failed submission, action contains failed answer
        case answerSubmittedFailure(Answer)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            /// Show progress view indicator and start fetching questions from API
            case .fetchQuestions:
                state.isPerformingNetworkCall = true
                return .run { send in
                    let questions = try? await self.surveyQuestionsAPIService.fetchQuestions()
                    await send(.questionsFetched(questions ?? []))
                }
                
            /// Questions have been fetched from API service
            case let .questionsFetched(questions):
                state.isPerformingNetworkCall = false
                state.questions = questions
                state.currentQuestionIndex = 0
                return .none
                
            /// This is run when previous button is tapped
            case .previousButtonTapped: //
                state.currentQuestionIndex -= 1
                return .none
            
            /// This is run when next button is tapped
            case .nextButtonTapped:
                state.currentQuestionIndex += 1
                return .none
                
            /// Show progress view to indicate upload and start the process
            case let .submitButtonTapped(answer):
                state.isPerformingNetworkCall = true
                
                return .run { send in
                    do {
                        try await self.surveyQuestionsAPIService.submitAnswer(answer)
                        await send(.answerSubmittedSuccessfully(answer))
                    } catch {
                        print("error \(error)")
                        await send(.answerSubmittedFailure(answer))
                    }
                }
                
            /// Answer has been sucessfully submitted to API
            case let .answerSubmittedSuccessfully(answer):
                state.isPerformingNetworkCall = false
                state.isShowingSuccessMessage.toggle() // trigger success notification banner
                state.answerToRetry = nil
                state.answersSubmitted.append(answer) // appends answer to successfully submitted list
                
                return .none
                
            /// Answer submission has failed
            case let .answerSubmittedFailure(answer):
                state.isPerformingNetworkCall = false
                state.isShowingFailureMessage.toggle()
                state.answerToRetry = answer // store answer to retry
                
                return .none
                
            /// Retry button has been tapped. Call the same action like on submit button with stored answer to retry
            case .retryButtonTapped:
                if let answer = state.answerToRetry {
                    return .run { send in
                        await send(.submitButtonTapped(answer))
                    }
                } else {
                    return .none
                }
            }
        }
    }
}
