//
//  MeleeHelpViewModel.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/17/24.
//

import Foundation
import SwiftUI


@MainActor class MeleeHelpViewModel: ObservableObject {
   
    
    private var openAI = OpenAIService()
    
    @Published var showUserPicker = false
    @Published var showEnemyPicker = false
    @Published var userCharacter: Character = CharacterData.allCharacters[0]
    @Published var enemyCharacter: Character = CharacterData.allCharacters[1]
    
    @Published var isLoading:Bool = false
    @Published var response:String = ""
    
//    func getResponse(userCharacter: String, enemyCharacter: String, helpType: String) async throws  {
//        let systemPrompt = "You are an expert super smash bros. melee tutor. You will be given the user's melee character, their opponents character, and then the type of advice they want. Give a response back that is specific to the type they wanted and in the matchup they are playing."
//        let userPrompt = "I am playing \(userCharacter) against \(enemyCharacter). Give me advice in this matchup specifically around the area of \(helpType)"
//        
//        await openAI.fetchChatCompletion(systemPrompt: systemPrompt , userPrompt: userPrompt){result in
//            DispatchQueue.main.async { [self] in
//                switch result {
//                case .success(let result):
//                    self.response = result
//                 
//                 
//                    
//                case .failure(let error):
//                    self.response = error.localizedDescription
//                }
//            
//            }
//        }
//        
//    }
    
    func getResponse(userCharacter: String, enemyCharacter: String, helpType: String) {
        isLoading = true
        let systemPrompt = "You are an expert super smash bros. melee tutor. You will be given the user's melee character, their opponents character, and then the type of advice they want. Give a response back that is specific to the type they wanted and in the matchup they are playing."
        let userPrompt = "I am playing \(userCharacter) against \(enemyCharacter). Give me advice in this matchup specifically around the area of \(helpType)"
        
        Task {
            do {
                self.response = try await openAI.fetchChatCompletion(systemPrompt: systemPrompt , userPrompt: userPrompt)
            } catch {
                self.response = error.localizedDescription
            }
            isLoading = false
        }
      
    }

}
