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
        // Access environment variables for debug in xcode
//        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"],
//              let organization = ProcessInfo.processInfo.environment["OPENAI_ORGANIZATION"] else {
//            throw InitializationError.missingEnvironmentVariables
//        }
      
        guard let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"],
              let organization = Bundle.main.infoDictionary?["OPENAI_ORGANIZATION"] else {
            throw InitializationError.missingEnvironmentVariables
        }

        
        // Initialize OpenAI client
        let configuration = OpenAI.Configuration(token: apiKey as! String, organizationIdentifier: organization as? String, timeoutInterval: 60.0)
        self.openAI = OpenAI(configuration: configuration)
    }
    
    func fetchChatCompletion(systemPrompt: String, userPrompt: String) async throws -> String {
        guard let openAI = openAI else {
            throw NSError(domain: "OpenAIErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "OpenAI client not initialized"])
        }

        let userMessage = ChatQuery.ChatCompletionMessageParam.user(.init(content: .string(userPrompt)))
        let systemMessage = ChatQuery.ChatCompletionMessageParam.system(.init(content: systemPrompt))
        let query = ChatQuery(
            messages: [systemMessage, userMessage],
            model: .gpt4_o,
            frequencyPenalty: 1,  // Penalize repetition
            maxTokens: 1000,
            presencePenalty: 1,  // Encourage new topics
            temperature: 1,  // Increase creativity
            topP: 0.8  // Consider more diverse options
        )
        
        do {
            let result = try await openAI.chats(query: query)
            guard let finalString = result.choices.first?.message.content?.string else {
                throw NSError(domain: "OpenAIErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No content found in response"])
            }
            return finalString
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
