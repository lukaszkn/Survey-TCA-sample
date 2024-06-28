//
//  MainViewFeature.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//

import ComposableArchitecture

@Reducer
struct MainViewFeature {
    
    @ObservableState
    struct State: Equatable {
    }
    
    enum Action {
        case initMainView
        case startButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
            case .initMainView:
                return .none
                
            case .startButtonTapped:
                return .none
            }
            
        }
    }
}
