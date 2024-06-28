//
//  AppFeature.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//
//  This is main app feature/reducer

import ComposableArchitecture

@Reducer
struct AppFeature {
    @Reducer(state: .equatable)
    enum Destination {
        /// Start screen destination
        case mainView(MainViewFeature)
        
        /// Survey questions destination
        case surveyQuestions(SurveyQuestionsFeature)
    }

    /// Combined master/details state
    @ObservableState
    struct State: Equatable {
        var mainViewState = MainViewFeature.State()
        var surveyQuestionState: SurveyQuestionsFeature.State?
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        /// Show start screen
        case mainView(MainViewFeature.Action)
        
        /// Show any child view
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            /// Handle master/details navigation here
            case .mainView(.startButtonTapped):
                state.surveyQuestionState = SurveyQuestionsFeature.State()
                state.destination = .surveyQuestions(state.surveyQuestionState!) // set navigation destination to survey questions
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        /// Scope for main view is created here
        Scope(state: \.mainViewState, action: \.mainView) {
            MainViewFeature() // create start screen feature
        }
    }
}
