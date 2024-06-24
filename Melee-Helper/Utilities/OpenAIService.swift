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
    private var openAI: OpenAI?

    init() {
        do {
            try initializeOpenAI()
        } catch {
            print("Failed to initialize OpenAI: \(error.localizedDescription)")
            // Handle initialization error appropriately, such as setting a flag or notifying the user
        }
    }
    
    private func initializeOpenAI() throws {
      
        guard let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"],
              let organization = Bundle.main.infoDictionary?["OPENAI_ORGANIZATION"] else {
            throw InitializationError.missingEnvironmentVariables
        }

        
        // Initialize OpenAI client
        let configuration = OpenAI.Configuration(token: apiKey as! String, organizationIdentifier: organization as? String, timeoutInterval: 60.0)
        self.openAI = OpenAI(configuration: configuration)
    }
    
    func fetchChatCompletion(messages: [ChatQuery.ChatCompletionMessageParam], newChat: Bool) async throws -> String {
        guard let openAI = openAI else {
            throw NSError(domain: "OpenAIErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "OpenAI client not initialized"])
        }

        let query = ChatQuery(
            messages: messages,
            model: .gpt4_o,
            frequencyPenalty: 0.1,  // Penalize repetition
            maxTokens: 1000,
            presencePenalty: 0, 
            responseFormat: ChatQuery.ResponseFormat.jsonObject,
            temperature: 0.3,  // Increase creativity
            topP: 1.0 // Consider more diverse options
        )
        //print(query.messages)
        do {
            let result = try await openAI.chats(query: query)
            guard let resultString = result.choices.first?.message.content?.string else {
                throw NSError(domain: "OpenAIErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No content found in response"])
            }
            return resultString
           
        } catch {
            throw error
        }
        
    }
    
    enum InitializationError: Error, LocalizedError {
        case missingEnvironmentVariables
        
        var errorDescription: String? {
            switch self {
            case .missingEnvironmentVariables:
                return NSLocalizedString("Required environment variables are missing.", comment: "Missing Environment Variables")
            }
        }
    }
}
