//
//  MeleeCharacterDetailView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI
import Kingfisher

struct MeleeCharacterDetailView: View {
    
    var character: Character
    
    @State private var isAnimating = true
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .center , spacing:20){
                MeleeCharacterTitleView(character: character)
                Text(character.description)
                    .font(.body)
                    .fontWeight(.medium)
                    .padding()
                
                
                
                ForEach(character.moveSet){ move in
                    MoveAnimationView(gifURL: move.moveAnimationURL)
                        .frame(width: 300, height: 300)
                }
                
                
            }
            .padding()
            
        }
        
    }
    
    
}

#Preview {
    MeleeCharacterDetailView(character: CharacterData.allCharacters[5])
}
