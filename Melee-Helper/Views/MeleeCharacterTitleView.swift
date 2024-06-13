//
//  MeleeCharacterTitleView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI

struct MeleeCharacterTitleView: View {
    
    var character: Character
    
    var body: some View {
        VStack{
            Image(character.imageName)
                .resizable()
                .frame(width:50, height:50)
            Text(character.name)
                .font(.title3)
                .fontWeight(.bold)
                .scaledToFit()
                .minimumScaleFactor(0.6)
        }
        .padding()
    }
}

#Preview {
    MeleeCharacterTitleView(character: CharacterData.allCharacters[1])
}
