//
//  SurveyQuestionFeature.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//

import ComposableArchitecture

@Reducer
struct SurveyQuestionFeature {
    
    @ObservableState
    struct State: Equatable {
    }
    
    enum Action {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
