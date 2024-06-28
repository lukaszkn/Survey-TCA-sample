//
//  Question.swift
//  Survey
//
//  Created by Lukasz on 28/06/2024.
//

import Foundation

struct Question: Codable {
    let id: Int
    let question: String
}

// Sample json from server
// {
//     "id": 1,
//     "question": "What is your favourite colour?"
// }
