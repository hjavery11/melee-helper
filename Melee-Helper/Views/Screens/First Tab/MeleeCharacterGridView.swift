//
//  MeleeCharacterGridView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI

struct MeleeCharacterGridView: View {
    @StateObject private var viewModel = MeleeCharacterGridViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                    LazyVGrid(columns: viewModel.columns, spacing: 20 ) {
                        ForEach(CharacterData.allCharacters) { character in
                            NavigationLink(value: character) {
                                MeleeCharacterTitleView(character: character)
                            }
                        }
                    }
                  
                }
                .navigationTitle("Characters")
                
                .navigationDestination(for: Character.self, destination: { character in
                    MeleeCharacterDetailView(character: character)
                })
                .padding()
            
        }
        .tint(Color(.label))
    }
}

#Preview {
    MeleeCharacterGridView()
}
