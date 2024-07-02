//
//  OpenAIModels.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/29/24.
//

import Foundation


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
    let response_format: ResponseFormat
    let messages: [Message]
}

struct ResponseFormat: Codable{
    let type:String
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
