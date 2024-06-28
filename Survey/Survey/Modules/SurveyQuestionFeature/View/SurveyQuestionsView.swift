//
//  SurveyQuestionView.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//

import ComposableArchitecture
import SwiftUI

struct SurveyQuestionsView: View {
    @Bindable var store: StoreOf<SurveyQuestionsFeature>
    
    var body: some View {
        VStack {
            Text("Questions submitted: 0")
                .font(.title2)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.gray.opacity(0.3))
                .padding(.top)
                
            VStack {
                Form {
                    Text("Question text").font(.headline)
                    TextField("", text: $store.answerText, prompt: Text("Type your answer here"))
                }
                .frame(height: 140)
                
                Button("Submit") {
                    
                }
                .buttonStyle(.borderedProminent)
                .disabled(store.answerText.isEmpty)
            }
            .background(Color(.systemGroupedBackground))
            .padding(.top, -7)

            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemGroupedBackground))
            
        }
        .navigationTitle("Question \(store.currentQuestionIndex + 1)/\(store.questions.count)")
        .toolbarRole(.editor)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Previous") {
                store.send(.previousButtonTapped)
            }
            .disabled(store.currentQuestionIndex == 0)
            
            Button("Next") {
                store.send(.nextButtonTapped)
            }
            .disabled(store.currentQuestionIndex == store.questions.count - 1)
        }
        .onAppear() {
            store.send(.fetchQuestions)
        }
    }
}

#Preview {
    NavigationStack {
        SurveyQuestionsView(store: Store(initialState: SurveyQuestionsFeature.State()) {
            SurveyQuestionsFeature()
        })
    }
}
