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
    
    
    //    init() {
    //        //For testing to not waste GPT queries
    //        self.response = "In the Donkey Kong vs. Link matchup, neutral can be challenging but manageable with some key strategies: 1. Dealing with Projectiles: Link's primary tools in neutral include his boomerang and arrows. These projectiles can disrupt your approach and set up for his close-range attacks. Use DK’s shield effectively to block these projectiles while slowly advancing forward or finding opportunities to weave around them. 2. Grounded Movement: Utilize Donkey Kong’s ground speed and long limbs to your advantage. Dash dancing is crucial here; it allows you to bait out moves from Link while staying unpredictable in your movement. 3. Space Control with Tilts: Your down-tilt (d-tilt) is a great tool for poking at mid-range due to its range and speed, which can interrupt Link’s setup attempts or force him into defensive options like shielding or jumping. 4. Punishing Approaches: If Link tries to approach with aerials, use up-tilt (u-tilt) as an anti-air option since it covers above DK quite well and leads into combos at lower percentages. 5. Grab Opportunities: Grabs are vital in this matchup because of DK’s powerful throw game: Cargo Up Throw -> Up Air works well on heavier characters like Link. Back Throw near ledges puts him off-stage where you can edgeguard effectively. 6. Utilizing Platforms: On stages with platforms, try using them to avoid grounded projectile spam and come down safely after being launched upwards by juggling through platform drops mixed with spaced aerials. 7. Edge Play & Recovery Mix-Ups: When recovering, mix-up between vertical recovery using Spinning Kong (up-B) or horizontal recovery using double jump combined with air dodge if necessary. Offensively edgeguarding against Links’ tether recoveries involves intercepting early tethers before they snap onto the ledge using back airs or quick dair spikes if timed right when he comes close vertically below stage level. 8. Avoid predictable approaches: Be wary of mindlessly approaching from the front as that makes you susceptible to getting caught by Link's f-smash/d-smash/grab game etc. Instead, condition responses then exploit patterns observed accordingly! By incorporating these points into your gameplay during neutral exchanges against a skilled Link player should greatly improve match-up performance overall!"
    //    }
    
    
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



