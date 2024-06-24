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
    
        
        VStack(alignment: .center , spacing:20){
            MeleeCharacterTitleView(character: character)
            Text(character.description)
                .font(.body)
                .fontWeight(.medium)
                .padding()
            
            
         
            KFAnimatedImage(URL(fileURLWithPath: Bundle.main.path(forResource: "FoxDTiltSSBM", ofType: "gif")!))
                      .frame(width: 300, height: 300)
    
        }
        .padding()
        
    }
    

    
    
}

#Preview {
    MeleeCharacterDetailView(character: CharacterData.allCharacters[0])
}
