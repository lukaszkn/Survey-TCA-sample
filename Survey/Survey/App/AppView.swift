//
//  ContentView.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        NavigationStack {
            MainView(store: store.scope(state: \.mainViewState, action: \.mainView))
            .navigationDestination(item: $store.scope(state: \.destination?.surveyQuestions, action: \.destination.surveyQuestions)) { store in
                SurveyQuestionsView(store: store)
            }
            .onAppear() {
                store.send(.mainView(.initMainView)) // initialise MainViewFeature reducer
            }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
