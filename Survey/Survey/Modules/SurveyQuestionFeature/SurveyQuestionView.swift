//
//  SurveyQuestionView.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//

import ComposableArchitecture
import SwiftUI

struct SurveyQuestionView: View {
    let store: StoreOf<SurveyQuestionFeature>
    
    var body: some View {
        Text("Survey questions")
            .navigationTitle("Question 1/20")
            .toolbarRole(.editor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Previous") { }
                Button("Next") { }
            }
    }
}

#Preview {
    NavigationStack {
        SurveyQuestionView(store: Store(initialState: SurveyQuestionFeature.State()) {
            SurveyQuestionFeature()
        })
    }
}
