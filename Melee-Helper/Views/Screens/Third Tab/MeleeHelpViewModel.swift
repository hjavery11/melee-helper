//
//  MeleeHelpViewModel.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/17/24.
//

import Foundation
import SwiftUI

enum HelpType: String, CaseIterable, Identifiable {
    case neutral, punish, defense
    var id: Self { self }
}

@MainActor class MeleeHelpViewModel: ObservableObject {
   
    
    private var openAI = OpenAIService()    

    
    @Published var showUserPicker = false
    @Published var showEnemyPicker = false
    @Published var userCharacter: Character = CharacterData.allCharacters[0]
    @Published var enemyCharacter: Character = CharacterData.allCharacters[1]
    
    @Published var isLoading:Bool = false
    @Published var response:String = ""    
    
    init() {
        //For testing to not waste GPT queries
        self.response = "In the Donkey Kong vs. Link matchup, neutral can be challenging but manageable with some key strategies: 1. Dealing with Projectiles: Link's primary tools in neutral include his boomerang and arrows. These projectiles can disrupt your approach and set up for his close-range attacks. Use DK’s shield effectively to block these projectiles while slowly advancing forward or finding opportunities to weave around them. 2. Grounded Movement: Utilize Donkey Kong’s ground speed and long limbs to your advantage. Dash dancing is crucial here; it allows you to bait out moves from Link while staying unpredictable in your movement. 3. Space Control with Tilts: Your down-tilt (d-tilt) is a great tool for poking at mid-range due to its range and speed, which can interrupt Link’s setup attempts or force him into defensive options like shielding or jumping. 4. Punishing Approaches: If Link tries to approach with aerials, use up-tilt (u-tilt) as an anti-air option since it covers above DK quite well and leads into combos at lower percentages. 5. Grab Opportunities: Grabs are vital in this matchup because of DK’s powerful throw game: Cargo Up Throw -> Up Air works well on heavier characters like Link. Back Throw near ledges puts him off-stage where you can edgeguard effectively. 6. Utilizing Platforms: On stages with platforms, try using them to avoid grounded projectile spam and come down safely after being launched upwards by juggling through platform drops mixed with spaced aerials. 7. Edge Play & Recovery Mix-Ups: When recovering, mix-up between vertical recovery using Spinning Kong (up-B) or horizontal recovery using double jump combined with air dodge if necessary. Offensively edgeguarding against Links’ tether recoveries involves intercepting early tethers before they snap onto the ledge using back airs or quick dair spikes if timed right when he comes close vertically below stage level. 8. Avoid predictable approaches: Be wary of mindlessly approaching from the front as that makes you susceptible to getting caught by Link's f-smash/d-smash/grab game etc. Instead, condition responses then exploit patterns observed accordingly! By incorporating these points into your gameplay during neutral exchanges against a skilled Link player should greatly improve match-up performance overall!"
    }
    
    
    private var responseTask: Task<Void, Never>? = nil
    
    
    func getResponse(userCharacter: String, enemyCharacter: String, helpType: String) {
        isLoading = true
        let systemPrompt = "You are an expert super smash bros. melee tutor. You will be given the user's melee character, their opponents character, and then the type of advice they want. Give a response back that is specific to the type they wanted and in the matchup they are playing."
        let userPrompt = "I am playing \(userCharacter) against \(enemyCharacter). Give me advice in this matchup specifically around the area of \(helpType)"
        
        responseTask = Task {
            do {
                self.response = try await openAI.fetchChatCompletion(systemPrompt: systemPrompt , userPrompt: userPrompt, newChat: true)
            } catch {
                self.response = error.localizedDescription
            }
            isLoading = false
        }
      
    }
    
    func cancelResponseTask() {
            responseTask?.cancel()
            responseTask = nil
        }

}

struct MeleeQueryObject {
    let userCharacter: Character
    let enemyCharacter: Character
    let helpType: HelpType
    
    
    
}
