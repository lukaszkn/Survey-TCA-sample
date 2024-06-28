//
//  SurveyQuestionsAPIService.swift
//  Survey
//
//  Created by Lukasz on 28/06/2024.
//

import ComposableArchitecture
import Foundation

struct SurveyQuestionsAPIService {
    var fetchQuestions: () async throws -> [Question]
    
    var submitAnswer: (Question) async throws -> Void
}

extension SurveyQuestionsAPIService: DependencyKey {
    static var liveValue: SurveyQuestionsAPIService = Self {
        let questions: [Question] = try await request(url: "https://xm-assignment.web.app/questions")
        return questions
    } submitAnswer: { question in
        print("\(question)")
    }

}

extension DependencyValues {
    var surveyQuestionsAPIService: SurveyQuestionsAPIService {
        get { self[SurveyQuestionsAPIService.self] }
        set {
            self[SurveyQuestionsAPIService.self] = newValue
        }
    }
}

extension SurveyQuestionsAPIService {
    private static func request<T: Decodable>(url: String) async throws -> T {
        guard let linkURL = URL(string: url) else {
            throw APIError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: linkURL)
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch let error {
            print(error.localizedDescription)
            throw APIError.decodingFailed
        }
    }
    
    enum APIError: Error {
        case invalidUrl
        case invalidData
        case decodingFailed
    }
}
