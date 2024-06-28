//
//  SurveyQuestionFeature.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//

import ComposableArchitecture

@Reducer
struct SurveyQuestionsFeature {
    @Dependency(\.surveyQuestionsAPIService) var surveyQuestionsAPIService
    
    @ObservableState
    struct State: Equatable {
        var isLoading: Bool = false
        var isShowingSuccessMessage: Bool = false
        var isShowingFailureMessage: Bool = false
        
        var questions: [Question] = []
        var currentQuestionIndex: Int = 0
        
        var answerText = ""
        
        static func == (lhs: SurveyQuestionsFeature.State, rhs: SurveyQuestionsFeature.State) -> Bool {
            lhs.isLoading == rhs.isLoading && lhs.questions.count == rhs.questions.count
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case fetchQuestions
        case questionsFetched([Question])
        
        case previousButtonTapped
        case nextButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .fetchQuestions:
                state.isLoading = true
                return .run { send in
                    let questions = try? await self.surveyQuestionsAPIService.fetchQuestions()
                    await send(.questionsFetched(questions ?? []))
                }
                
            case let .questionsFetched(questions):
                state.isLoading = false
                state.questions = questions
                state.currentQuestionIndex = 0
                return .none
                
            case .binding:
                return .none
                
            case .previousButtonTapped:
                state.currentQuestionIndex -= 1
                return .none
                
            case .nextButtonTapped:
                state.currentQuestionIndex += 1
                return .none
                
            }
        }
    }
}
