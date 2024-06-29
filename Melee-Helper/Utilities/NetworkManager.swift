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
    
    
    func fetchCompletion() async throws -> OpenAIResponse {
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
            request.httpBody = try JSONEncoder().encode(OpenAIRequest(model: .gpt4_0, messages: [Message(role: OpenAIRole.user.rawValue, content: "What is the current day and time?")]))
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let responseValue = String(data: data, encoding: .utf8)
            print(responseValue ?? "No response")
            
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

enum OpenAIModel: String, Codable {
    case gpt4_0 = "gpt-4o"
    case gpt4_turbo = "gpt-4-turbo"
    case gpt4 = "gpt-4"
}

enum OpenAIRole: String, Codable {
    case assistant, user, system
}


struct Message: Codable {
    let role: String
    let content: String
}

struct OpenAIRequest: Codable{
    let model: OpenAIModel
    let messages: [Message]
    
    
}

//{
//  "choices": [
//    {
//      "finish_reason": "stop",
//      "index": 0,
//      "message": {
//        "content": "The 2020 World Series was played in Texas at Globe Life Field in Arlington.",
//        "role": "assistant"
//      },
//      "logprobs": null
//    }
//  ],
//  "created": 1677664795,
//  "id": "chatcmpl-7QyqpwdfhqwajicIEznoc6Q47XAyW",
//  "model": "gpt-3.5-turbo-0613",
//  "object": "chat.completion",
//  "usage": {
//    "completion_tokens": 17,
//    "prompt_tokens": 57,
//    "total_tokens": 74
//  }
//}


struct OpenAIResponse: Codable {
    let choices: [Choice]
    let created: Int
    let id: String
    let model: String
    let object: String
    let usage: Usage
    
    struct Choice: Codable {
        let finish_reason: String
        let index: Int
        let message: Message
    }
    
    struct Usage: Codable {
        let completion_tokens: Int
        let prompt_tokens: Int
        let total_tokens: Int
    }
}
