//
//  SurveyQuestionView.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//
//  This is view containing submitted questions navigation and info toolbar, question/asnwer form.
//  It also handles success/failure messages

import ComposableArchitecture
import SwiftUI
import SwiftMessages

struct SurveyQuestionsView: View {
    var store: StoreOf<SurveyQuestionsFeature>
    
    var body: some View {
        VStack {
            /// Show how many question have been sucessfully submitted already
            Text("Questions submitted: \(store.answersSubmitted.count)")
                .font(.title2)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.gray.opacity(0.3))
                .padding(.top)

            /// If the current question exits, show form to fill it
            if let question = store.currentQuestion {
                QuestionView(question: question, answer: store.currentAnswer) { answer in
                    store.send(.submitButtonTapped(answer))
                }
            }

            /// Show progress indicator below submit button
            VStack {
                if store.isPerformingNetworkCall {
                    ProgressView() // this will show loading indicator when loading questions or submiting answer
                        .padding()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemGroupedBackground))
            .padding(.top, -8)
        }
        /// Show questions answering progress e.g. 3 of 10
        .navigationTitle("Question \(store.currentQuestionIndex + 1)/\(store.questions.count)")
        .toolbarRole(.editor)
        .navigationBarTitleDisplayMode(.inline)
        
        /// Present toolbar buttons for question navigation
        .toolbar {
            Button("Previous") {
                store.send(.previousButtonTapped)
            }
            .disabled(store.currentQuestionIndex == 0) // disable Previous button for first question
            
            Button("Next") {
                store.send(.nextButtonTapped)
            }
            .disabled(store.currentQuestionIndex == store.questions.count - 1) // disable Next button for last question
        }
        
        /// Show success message
        .onChange(of: store.isShowingSuccessMessage, {
            SwiftMessages.hideAll()
            let messageView = MessageHostingView(id: UUID().uuidString, content: SuccessDialogMessageView())
            SwiftMessages.show(view: messageView) // show notification for couple seconds only
        })
        
        /// Show failure message with retry button
        .onChange(of: store.isShowingFailureMessage, {
            SwiftMessages.hideAll()
            let messageView = MessageHostingView(id: UUID().uuidString, content: FailureDialogMessageView() {
                Button("Retry") {
                    store.send(.retryButtonTapped)
                }
                .buttonStyle(.borderedProminent)
            })
            
            var config = SwiftMessages.Config()
            config.duration = .forever // show notification permanently until user dismisses it
            SwiftMessages.show(config: config, view: messageView)
        })
        .onAppear() {
            store.send(.fetchQuestions) // load questions on screen appear
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
