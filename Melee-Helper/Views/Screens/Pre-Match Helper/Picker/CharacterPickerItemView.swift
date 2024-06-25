//
//  PickerTest.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/17/24.
//

import SwiftUI

struct CharacterPickerItemView: View {
    
    let character: Character
    
    var body: some View {
        HStack {
            Image(character.imageName)
                .resizable()
                .frame(width: 50, height: 50)
            Text(character.name)
                .font(.headline)
        }
        
    }
}

#Preview {
    CharacterPickerItemView(character: CharacterData.allCharacters[0])
}
