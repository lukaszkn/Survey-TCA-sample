//
//  MainView.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    let store: StoreOf<MainViewFeature>
    
    var body: some View {
        VStack {
            Button("Start survey") {
                store.send(.startButtonTapped)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Welcome")
    }
}

#Preview {
    MainView(store: Store(initialState: MainViewFeature.State()) {
        MainViewFeature()
    })
}
