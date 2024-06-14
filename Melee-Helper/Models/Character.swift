//
//  Character.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import Foundation
import UIKit

struct Character:Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
    
    
    func recognizeCharacter(from image: UIImage) -> Character? {
        // Simulate character recognition with a random character
        return CharacterData.allCharacters.randomElement()
    }
}

