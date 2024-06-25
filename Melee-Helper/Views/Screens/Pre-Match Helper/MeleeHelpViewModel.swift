//
//  MeleeHelpViewModel.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/17/24.
//

import Foundation
import SwiftUI
import OpenAI
import UIKit

enum HelpType: String, CaseIterable, Identifiable {
   case gameplan = "Basic Gameplan"
    case neutral = "Neutral Game"
    case punish = "Punish Game"
    case defense = "Defensive Play"
    var id: Self { self }
}

enum SkillType: String, CaseIterable, Identifiable {
    case beginner, intermediate, advanced
    var id: Self { self }
}



@MainActor class MeleeHelpViewModel: ObservableObject {
    
    
    private var openAI = OpenAIService()
   
    @Published var showUserPicker = false
    @Published var showEnemyPicker = false
    @Published var isLoading:Bool = false
    @Published var response:String = ""
    @Published var currentTaskID: UUID?
    
    @Published var userCharacter: Character = CharacterData.allCharacters[5]
    @Published var enemyCharacter: Character = CharacterData.allCharacters[10]
    @Published var helpType: HelpType = .gameplan
    @Published var skillType: SkillType = .intermediate
    
    private var currentQuery: MeleeQuery?

    private var responseTask: Task<Void, Never>? = nil
    
    
    func getResponse() {
        let taskID = UUID()
        currentTaskID = taskID
        
        let query = MeleeQuery(userCharacter: userCharacter, enemyCharacter: enemyCharacter, helpType: helpType, skillLevel: skillType)
        self.currentQuery = query
        isLoading = true
        
        responseTask = Task {
            do {              
                let response = try await openAI.fetchChatCompletion(messages: query.messageHistory, newChat: true)
                // Only update the response if the taskID matches the currentTaskID
                if taskID == currentTaskID {
                    self.response = response
                    self.currentQuery?.appendResponseMessage(response)
                }
            } catch {
                // Only update the response if the taskID matches the currentTaskID
                if taskID == currentTaskID {
                    self.response = error.localizedDescription
                }
            }
            if taskID == currentTaskID {
                isLoading = false
            }
        }
        
    }
    
    func getFollowUpResponse(followUpQuestion: String) {
        guard var query = currentQuery else { return }
        let taskID = UUID()
        currentTaskID = taskID
        
        query.appendUserMessage(followUpQuestion + " - Return any response in JSON following the structure of \(exampleJSONString)")
        isLoading = true
        
        responseTask = Task {
            do {
                var responseString = try await openAI.fetchChatCompletion(messages: query.messageHistory, newChat: false)
                
                // Only update the response if the taskID matches the currentTaskID
                if taskID == currentTaskID {
                    if ResponseBuilder().parseJSON(rawString: responseString) == nil {
                        print("json decoding failed in openAIService. Attempting to resubmit")
                        let retryMessage = ChatQuery.ChatCompletionMessageParam(role: .user, content: "This did not follow the correct JSON format I gave you. Return it following the correct format.")
                        query.messageHistory.append(retryMessage!)
                        responseString = try await openAI.fetchChatCompletion(messages: query.messageHistory, newChat: false)
                    }
                    self.response = responseString
                    query.appendResponseMessage(responseString)
                    self.currentQuery = query
                  
                }
            } catch {
                // Only update the response if the taskID matches the currentTaskID
                if taskID == currentTaskID {
                    self.response = error.localizedDescription
                }
            }
            if taskID == currentTaskID {
                isLoading = false
            }
        }       
    }
    
    func cancelResponseTask() {
        responseTask?.cancel()
        responseTask = nil
        currentTaskID = nil // Invalidate the current task
    }
    
    func swapCharacters() {
        let storedUserCharacter = userCharacter
        let storedEnemyCharacter = enemyCharacter
        
        userCharacter = storedEnemyCharacter
        enemyCharacter = storedUserCharacter
    }
    
}

struct MeleeQuery {
    var userCharacter: Character
    var enemyCharacter: Character
    var helpType: HelpType
    var skillLevel: SkillType
    var helpMessage: String
    

    
    
    var messageHistory: [ChatQuery.ChatCompletionMessageParam]
    
    init(userCharacter: Character, enemyCharacter: Character, helpType: HelpType, skillLevel: SkillType) {
        self.userCharacter = userCharacter
        self.enemyCharacter = enemyCharacter
        self.helpType = helpType
        self.skillLevel = skillLevel
        
        switch self.helpType {
        case .defense:
            self.helpMessage = "Give me advice specfically around defense and defensive play."
        case .gameplan:
            self.helpMessage = "Generate a basic gameplan for me to follow to win this matchup."
        case .neutral:
            self.helpMessage = "Give me advice specfically around neutral game."
        case .punish:
            self.helpMessage = "Give me advice specfically around punish game."
        }
        
        self.messageHistory = [
            .system(.init(content: "You are an expert super smash bros. melee coach. You will be given the user's melee character, their opponents character,the type of advice they want, and their general skill level. Give a response back that is specific to the type they wanted and in the matchup they are playing. Do not give any information or answer any questions that dont directly apply to super smash brothers melee. If they ask something unrelated, return a simple message only using the overview field telling them why you couldn't answer their question. Return any responses back in JSON format that conforms to this model so it always decodable: \(exampleJSONString)")),
            
            .user(.init(content: .string("I am playing \(userCharacter) against \(enemyCharacter). \(helpMessage) Keep your advice helpful to a player of my skill level of: \(skillLevel)")))
        ]
        
      
    }
    
    
    mutating func appendUserMessage(_ message: String) {
        self.messageHistory.append(.user(.init(content: .string(message))))
    }
    
    mutating func appendResponseMessage(_ message: String) {
        self.messageHistory.append(.assistant(.init(content: message)))
    }
}



