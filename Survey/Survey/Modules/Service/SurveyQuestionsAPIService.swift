//
//  SurveyQuestionsAPIService.swift
//  Survey
//
//  Created by Lukasz on 28/06/2024.
//
//  This is API service for populating questions list and submitting the answer
//  TODO: It should be refactored to split networking to separate class/struct to make it more generic

import ComposableArchitecture
import Foundation

struct SurveyQuestionsAPIService {
    var fetchQuestions: () async throws -> [Question]
    
    var submitAnswer: (Answer) async throws -> Void
}

extension SurveyQuestionsAPIService: DependencyKey {
    /// This is for live API environment
    static var liveValue: SurveyQuestionsAPIService = Self {
        let questions: [Question] = try await request(url: "https://xm-assignment.web.app/questions")
        return questions
    } submitAnswer: { answer in
        try await post(url: "https://xm-assignment.web.app/question/submit", data: answer)
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
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }
        
        guard httpResponse.statusCode <= 299 else {
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
    
    private static func post<T: Encodable>(url: String, data: T) async throws {
        guard let linkURL = URL(string: url) else {
            throw APIError.invalidUrl
        }
        
        let payload = try JSONEncoder().encode(data)
        var urlRequest = URLRequest(url: linkURL)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        let (_, response) = try await URLSession.shared.upload(for: urlRequest, from: payload)
        
        guard let httpResponse = (response as? HTTPURLResponse) else {
            throw APIError.invalidData
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        default:
            throw APIError.uploadFailed
        }
    }
    
    enum APIError: Error {
        case invalidUrl
        case invalidData
        case decodingFailed
        case uploadFailed
    }
}
