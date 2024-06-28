//
//  QuestionView.swift
//  Survey
//
//  Created by Lukasz on 28/06/2024.
//
//  This is view containing question/answer form and submit button. UI view logic only

import SwiftUI

struct QuestionView: View {
    /// Question to show in the form
    var question: Question
    
    /// Potentially already answered question
    var answer: Answer?
    
    /// Binding for answer text field
    @State private var answerString: String = ""
    
    /// Submission action to be called after pressing Submit button
    var submitAction: (Answer) -> Void
    
    var body: some View {
        VStack {
            Form {
                Text(question.question).font(.headline)
                TextField("", text: $answerString, prompt: Text("Type your answer here"))
                    .disabled(answer != nil) // disable editing if answer was sent successfully
            }
            .frame(height: 140)
            
            Button(answer != nil ? "Already submitted" : "Submit") {
                // TODO: should we disable submit button if user presses the button?
                submitAction(Answer(id: question.id, answer: answerString))
            }
            .buttonStyle(.borderedProminent)
            .disabled(answerString.isEmpty || answer != nil) // disable button if answer is empty or answer was already submitted
        }
        .background(Color(.systemGroupedBackground))
        .padding(.top, -7)
        .onChange(of: question, {
            /// Update textfield with already answered question or assign blank answer. This happens when question changes
            if let answer {
                self.answerString = answer.answer
            } else {
                self.answerString = ""
            }
        })
    }
}
