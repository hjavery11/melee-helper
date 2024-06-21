//
//  MeleeHelpViewModel.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/17/24.
//

import Foundation
import SwiftUI
import OpenAI

enum HelpType: String, CaseIterable, Identifiable {
    case neutral, punish, defense
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
    @Published var helpType: HelpType = .neutral
    
    private var currentQuery: MeleeQuery?
    
    
    //    init() {
    //        //For testing to not waste GPT queries
    //        self.response = "In the Donkey Kong vs. Link matchup, neutral can be challenging but manageable with some key strategies: 1. Dealing with Projectiles: Link's primary tools in neutral include his boomerang and arrows. These projectiles can disrupt your approach and set up for his close-range attacks. Use DK’s shield effectively to block these projectiles while slowly advancing forward or finding opportunities to weave around them. 2. Grounded Movement: Utilize Donkey Kong’s ground speed and long limbs to your advantage. Dash dancing is crucial here; it allows you to bait out moves from Link while staying unpredictable in your movement. 3. Space Control with Tilts: Your down-tilt (d-tilt) is a great tool for poking at mid-range due to its range and speed, which can interrupt Link’s setup attempts or force him into defensive options like shielding or jumping. 4. Punishing Approaches: If Link tries to approach with aerials, use up-tilt (u-tilt) as an anti-air option since it covers above DK quite well and leads into combos at lower percentages. 5. Grab Opportunities: Grabs are vital in this matchup because of DK’s powerful throw game: Cargo Up Throw -> Up Air works well on heavier characters like Link. Back Throw near ledges puts him off-stage where you can edgeguard effectively. 6. Utilizing Platforms: On stages with platforms, try using them to avoid grounded projectile spam and come down safely after being launched upwards by juggling through platform drops mixed with spaced aerials. 7. Edge Play & Recovery Mix-Ups: When recovering, mix-up between vertical recovery using Spinning Kong (up-B) or horizontal recovery using double jump combined with air dodge if necessary. Offensively edgeguarding against Links’ tether recoveries involves intercepting early tethers before they snap onto the ledge using back airs or quick dair spikes if timed right when he comes close vertically below stage level. 8. Avoid predictable approaches: Be wary of mindlessly approaching from the front as that makes you susceptible to getting caught by Link's f-smash/d-smash/grab game etc. Instead, condition responses then exploit patterns observed accordingly! By incorporating these points into your gameplay during neutral exchanges against a skilled Link player should greatly improve match-up performance overall!"
    //    }
    
    
    private var responseTask: Task<Void, Never>? = nil
    
    
    func getResponse() {
        let taskID = UUID()
        currentTaskID = taskID
        
        let query = MeleeQuery(userCharacter: userCharacter, enemyCharacter: enemyCharacter, helpType: helpType)
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
        self.response = ""
        guard var query = currentQuery else { return }
        let taskID = UUID()
        currentTaskID = taskID
        
        query.appendUserMessage(followUpQuestion)
        isLoading = true
        
        responseTask = Task {
            do {
                let response = try await openAI.fetchChatCompletion(messages: query.messageHistory, newChat: false)
                
                // Only update the response if the taskID matches the currentTaskID
                if taskID == currentTaskID {
                    self.response = response
                    query.appendResponseMessage(response)
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
    
}

struct MeleeQuery {
    var userCharacter: Character
    var enemyCharacter: Character
    var helpType: HelpType
    
    var firstMessage: String {
        "I am playing \(userCharacter) against \(enemyCharacter). Give me advice in this matchup specifically around the area of \(helpType)"
    }
    
    var messageHistory: [ChatQuery.ChatCompletionMessageParam]
    
    init(userCharacter: Character, enemyCharacter: Character, helpType: HelpType) {
        self.userCharacter = userCharacter
        self.enemyCharacter = enemyCharacter
        self.helpType = helpType
        self.messageHistory = [
            .system(.init(content: "You are an expert super smash bros. melee tutor. You will be given the user's melee character, their opponents character, and then the type of advice they want. Give a response back that is specific to the type they wanted and in the matchup they are playing. Do not give any information or answer any questions that dont directly apply to super smash brothers melee.")),
            .user(.init(content: .string("I am playing \(userCharacter) against \(enemyCharacter). Give me advice in this matchup specifically around the area of \(helpType)")))
        ]
    }
    
    
    mutating func appendUserMessage(_ message: String) {
        self.messageHistory.append(.user(.init(content: .string(message))))
    }
    
    mutating func appendResponseMessage(_ message: String) {
        self.messageHistory.append(.assistant(.init(content: message)))
    }
    
    
}


let exampleQuery = MeleeQuery(userCharacter: CharacterData.allCharacters[0], enemyCharacter: CharacterData.allCharacters[1], helpType: HelpType.neutral)
