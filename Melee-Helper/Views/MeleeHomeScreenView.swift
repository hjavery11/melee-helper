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
                            MeleeCharacterTitleView(character: character)
                                .onTapGesture {
                                    viewModel.selectedCharacter = character
                                }
                        }
                    }
                }
                .navigationTitle("Characters")
                .font(.title)
                .padding()
                
                .sheet(isPresented: $viewModel.isShowingDetailView) {
                    MeleeCharacterDetailView(isShowingDetailView: $viewModel.isShowingDetailView, character:
                                                viewModel.selectedCharacter!)
                }
                
            }
        }
    }
}

#Preview {
    MeleeHomeScreenView()
}
