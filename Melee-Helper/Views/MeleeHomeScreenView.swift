//
//  ContentView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI

struct MeleeHomeScreenView: View {
    
    @StateObject private var viewModel = MeleeHomeScreenViewModel()
    
    let columns: [GridItem] = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    
    
    var body: some View {
        NavigationStack {
            ZStack{
                MainBackgroundView()
                ScrollView {
                    LazyVGrid(columns: columns) {
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
        }
        .tint(Color(.label))
    }
}

#Preview {
    MeleeHomeScreenView()
}
