//
//  Question.swift
//  Survey
//
//  Created by Lukasz on 28/06/2024.
//
//  Question model with identifier and question text

struct Question: Codable, Equatable {
    /// Question identifier
    let id: Int
    /// Question text
    let question: String
}

// Sample json from server
// {
//     "id": 1,
//     "question": "What is your favourite colour?"
// }
