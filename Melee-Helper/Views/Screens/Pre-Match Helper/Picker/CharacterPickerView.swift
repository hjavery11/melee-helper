//
//  CharacterPickerView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/17/24.
//

import SwiftUI

struct CharacterPickerView: View {
    
    @Binding var selectedCharacter: Character
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            List(CharacterData.allCharacters.sorted(by: {$0.name < $1.name}), id: \.self){ character in
                Button {
                    selectedCharacter = character
                    isPresented = false
                } label: {
                    CharacterPickerItemView(character: character)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Select Character")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") {
                        isPresented = false
                    }
                }
            }
        }
        .tint(Color(.label))
    }
}

#Preview {
    CharacterPickerView(selectedCharacter: .constant(CharacterData.allCharacters.first!), isPresented: .constant(true))
}
