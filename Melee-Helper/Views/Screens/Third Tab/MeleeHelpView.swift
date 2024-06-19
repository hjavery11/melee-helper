//
//  MeleeHelpView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/14/24.
//

import SwiftUI

enum Help: String, CaseIterable, Identifiable {
    case neutral, punish, defense
    var id: Self { self }
}



struct MeleeHelpView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = MeleeHelpViewModel()
    
    @State private var helpType: Help = .neutral
    
    private var shadowColor: Color {
            colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2)
        }
  
    
    var body: some View {
        NavigationStack {
            VStack(spacing:50){
                HStack(spacing:50){
                    Button{
                        viewModel.showUserPicker.toggle()
                    }label: {
                        Image(viewModel.userCharacter.imageName)
                            .resizable()
                            .frame(width:80, height:80)
                    }
                    .sheet(isPresented: $viewModel.showUserPicker) {
                        CharacterPickerView(selectedCharacter: $viewModel.userCharacter, isPresented: $viewModel.showUserPicker)
                    }
                    
                    VStack{
                        Text("vs.")
                            .font(.title)
                    }
                    .padding(.top,40)
                    
                    
                    Button{
                        viewModel.showEnemyPicker.toggle()
                    }label: {
                        Image(viewModel.enemyCharacter.imageName)
                            .resizable()
                            .frame(width:80, height:80)
                    }
                    .sheet(isPresented: $viewModel.showEnemyPicker) {
                        CharacterPickerView(selectedCharacter: $viewModel.enemyCharacter, isPresented: $viewModel.showEnemyPicker)
                    }
                    
                }
                
                
                
                
                
                Picker("Help", selection: $helpType){
                    ForEach(Help.allCases) { helpType in
                        Text(helpType.rawValue.capitalized)
                        
                    }
                }
                .pickerStyle(.segmented)                  
                
                
                
                Button {
                    viewModel.response = ""
                    Task{
                        viewModel.getResponse(userCharacter: viewModel.userCharacter.name, enemyCharacter: viewModel.enemyCharacter.name, helpType: helpType.rawValue)
                    }
                    
                } label: {
                    Text("Get Advice")
                        .frame(width: 150, height: 50)
                        .font(.title2)
                        .foregroundStyle(.white)
                        .background(.meleeRed)
                        .clipShape(.rect(cornerRadius: 10))
                    
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.5:1)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(color: shadowColor, radius: 5, x: 0, y: 5)
                    
                    
                    ScrollView{
                        VStack{
                            if (viewModel.response != "") {
                                Text(viewModel.response)
                                    .padding()
                              
                            }
                            
                            if(viewModel.isLoading) {
                                VStack{
                                    LoadingView()
                                        .offset(y:100)
                                }
                              
                            }
                        }
                    
                    }
                }
                .padding([.bottom],10)
                
            }
            .padding()
            .navigationTitle("Melee AI Helper")
          

            
        }
        .padding()
    }
    
    
    
}


#Preview {
    MeleeHelpView()
}
