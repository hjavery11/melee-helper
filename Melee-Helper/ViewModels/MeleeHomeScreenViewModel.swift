//
//  MeleeHomeScreenViewModel.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import Foundation

class MeleeHomeScreenViewModel: ObservableObject {
    
    
    var selectedCharacter: Character? {
        didSet{
            isShowingDetailView = true
        }
    }
    
    
   @Published var isShowingDetailView = false
    
}
