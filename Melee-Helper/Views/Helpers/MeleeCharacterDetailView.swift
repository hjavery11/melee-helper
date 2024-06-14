//
//  MeleeCharacterDetailView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI

struct MeleeCharacterDetailView: View {
    
    var character: Character
    
    var body: some View {
        ZStack{
            MainBackgroundView()
            VStack(alignment: .center , spacing:20){
                Spacer()
             
                MeleeCharacterTitleView(character: character)
                Text(character.description)
                    .font(.body)
                    .fontWeight(.medium)
                    .padding()
                
                Spacer()
                Spacer()
               
            }
            .padding()
            
           
        }
    }
}

#Preview {
    MeleeCharacterDetailView(character: CharacterData.allCharacters[0])
}
