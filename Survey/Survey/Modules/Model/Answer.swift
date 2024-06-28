//
//  Answer.swift
//  Survey
//
//  Created by Lukasz on 28/06/2024.
//
//  Answer model with identifier and answer text

struct Answer: Codable {
    /// Answer identifier
    let id: Int
    /// Answer text
    var answer: String
}

// Sample json to upload
// {
//     "id": 1,
//     "answer": "red"
// }
