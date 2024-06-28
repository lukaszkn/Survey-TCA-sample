//
//  AppFeature.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case mainView(MainViewFeature)
        case surveyQuestions(SurveyQuestionsFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var mainViewState = MainViewFeature.State()
        var surveyQuestionState: SurveyQuestionsFeature.State?
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case mainView(MainViewFeature.Action)
        case surveyQuestion(SurveyQuestionsFeature.Action)
        
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .mainView(.startButtonTapped):
                state.surveyQuestionState = SurveyQuestionsFeature.State()
                state.destination = .surveyQuestions(state.surveyQuestionState!)
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        Scope(state: \.mainViewState, action: \.mainView) {
            MainViewFeature()
        }
    }
}
