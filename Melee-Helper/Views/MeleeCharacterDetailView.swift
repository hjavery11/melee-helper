//
//  MeleeCharacterDetailView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI

struct MeleeCharacterDetailView: View {
    
    @Binding var isShowingDetailView: Bool
    var character: Character
    
    var body: some View {
        ZStack{
            MainBackgroundView()
            VStack(alignment: .center , spacing:20){
                HStack {
                    Spacer()
                    Button {
                        isShowingDetailView = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(.label))
                            .frame(width: 44, height: 44)
                    }
                }
                .padding()
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
    MeleeCharacterDetailView(isShowingDetailView: .constant(false), character: CharacterData.allCharacters[0])
}
