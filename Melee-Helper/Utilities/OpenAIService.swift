//
//  OpenAIService.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/17/24.
//

import Foundation
import OpenAI
import Combine

class OpenAIService: ObservableObject {
    private var openAI: OpenAI

    init() {
        // Access environment variables
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"],
              let organization = ProcessInfo.processInfo.environment["OPENAI_ORGANIZATION"] else {
            fatalError("Environment variables not set")
        }

        // Initialize OpenAI client
        let configuration = OpenAI.Configuration(token: apiKey, organizationIdentifier: organization, timeoutInterval: 60.0)
        self.openAI = OpenAI(configuration: configuration)
    }

    // Function to fetch a completion from OpenAI using async/await
    func fetchChatCompletion(systemPrompt: String, userPrompt: String, completed: @escaping (Result<String,Error>)-> Void) async {
        let userMessage = ChatQuery.ChatCompletionMessageParam.user(.init(content: .string(userPrompt)))
        let systemMessage = ChatQuery.ChatCompletionMessageParam.system(.init(content: systemPrompt))
           let query = ChatQuery(
               messages: [systemMessage,userMessage],
               model: .gpt4_o,
               frequencyPenalty: 1,  // Penalize repetition
               maxTokens: 1000,
               presencePenalty: 1,  // Encourage new topics
               temperature: 1,  // Increase creativity
               topP: 0.8  // Consider more diverse options
           )
           
           do {
               let result = try await openAI.chats(query: query)
               if let completion = result.choices.first?.message.content?.string {
                   DispatchQueue.main.async {
                       completed(.success(completion))
                   }
               }
           } catch {
               DispatchQueue.main.async {
                   completed(.failure(error))
               }
           }
       }
}

