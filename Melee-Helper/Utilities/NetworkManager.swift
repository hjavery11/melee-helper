//
//  NetworkManager.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/28/24.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"]
    let organizationKey = Bundle.main.infoDictionary?["OPENAI_ORGANIZATION"]
    
    init() {}
    
    let completionsURL = "https://api.openai.com/v1/chat/completions"
    
    
    func fetchCompletion(messages: [Message]) async throws -> OpenAIResponse {
        guard let url = URL(string: completionsURL) else {
            //invalid url
            throw NSError(domain: "OpenAIErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "OpenAI URL Incorrect"])
        }
        
        
        
        
        do {
            var request = URLRequest(url: url)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Authorization" : "Bearer \(apiKey ?? "")"
            ]
            request.httpBody = try JSONEncoder().encode(OpenAIRequest(model: .gpt4_0, response_format: ResponseFormat(type: "json_object"), messages: messages))
            
            let (data, _) = try await URLSession.shared.data(for: request)
            print("openAI request made")
            
            let responseValue = String(data: data, encoding: .utf8)
            
            
            do{
                let jsonResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
              
                return jsonResponse
            } catch {
                print(error)
                throw NSError(domain: "OpenAIErrorDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "decoder error"])
            }
            
            
        } catch {
            print("Failed to send completion request \(error)")
            throw NSError(domain: "OpenAIErrorDomain", code: 3, userInfo: [NSLocalizedDescriptionKey: "general error"])
        }
        
    }
    
    
    
}

//{
//    "model": "gpt-3.5-turbo",
//    "response_format": { "type": "json_object" },
//    "messages": [
//      {
//        "role": "system",
//        "content": "You are a helpful assistant."
//      },
//      {
//        "role": "user",
//        "content": "Who won the world series in 2020?"
//      },
//      {
//        "role": "assistant",
//        "content": "The Los Angeles Dodgers won the World Series in 2020."
//      },
//      {
//        "role": "user",
//        "content": "Where was it played?"
//      }
//    ]
//  }



