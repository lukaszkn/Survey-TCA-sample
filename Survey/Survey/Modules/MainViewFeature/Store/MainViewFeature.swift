//
//  MainViewFeature.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//
//  Start survey feature/reducer

import ComposableArchitecture

@Reducer
struct MainViewFeature {
    
    @ObservableState
    struct State: Equatable {
    }
    
    enum Action {
        /// Initial start screen state
        case initMainView
        
        /// Start button has been tapped
        case startButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            /// We are not handing any actions here at the moment
            switch action {
            case .initMainView:
                return .none
                
            case .startButtonTapped:
                return .none
            }
        }
    }
}
