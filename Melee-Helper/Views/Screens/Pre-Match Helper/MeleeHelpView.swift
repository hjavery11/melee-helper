//
//  MeleeHelpView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/14/24.
//

import SwiftUI





struct MeleeHelpView: View {    

  
    @StateObject private var viewModel = MeleeHelpViewModel()
    @State private var showAnswer = false
    @State private var generateGameplan = false
    
    @Environment(\.colorScheme) var colorScheme
   
  
    
    var body: some View {
        NavigationStack {
            VStack(spacing:70){
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
                    
                    VStack(spacing:5){
                        Button{
                            viewModel.swapCharacters()
                        } label: {
                            Image(systemName: "arrow.triangle.swap")
                                .imageScale(.large)
                                .rotationEffect(.degrees(90))
                                .offset(x: -2)
                        }
                        
                        Text("vs.")
                            .font(.title)
                         
                    }
               
                    
                    
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
                
                VStack{
                    HStack{
                        Text("Skill Level")
                            .font(.title2)
                        Spacer()
                        Picker("Skill Level", selection: $viewModel.skillType){
                            ForEach(SkillType.allCases) { helpType in
                                Text(helpType.rawValue.capitalized)
                            }
                        }
                   
                   
                      
                    }
                    .padding(.bottom, 0)
                    HStack{
                        Text("Help Type")
                            .font(.title2)
                   Spacer()
                        Picker("Help", selection: $viewModel.helpType){
                            ForEach(HelpType.allCases) { helpType in
                                Text(helpType.rawValue.capitalized)
                            }
                        }
                       
                    }
                }
                .frame(width: 300)
                .pickerStyle(.menu)
                .tint(Color(.label))
                
               
               
               
                
               
               
                
              
                
                Button {
                    viewModel.response = ""
                    Task{
                        viewModel.getResponse()
                        showAnswer = true
                    }
                    
                } label: {
                    Text("Get Advice")
                        .frame(width: 150, height: 50)
                        .font(.title2)
                        .foregroundStyle(.white)
                        .background(.meleeRed)
                        .clipShape(.rect(cornerRadius: 10))
                    
                }
                .fullScreenCover(isPresented: $showAnswer, onDismiss: didDismiss){
                    HelpResponseView(viewModel: viewModel)
                }
                
            }
            .padding()
            .toolbar {
                              ToolbarItem(placement: .principal) {
                                  HStack {
                                 
                                      Text("Melee Coach")
                                          .font(.largeTitle)
                                      Image("ssbm_icon")
                                          .resizable()
                                          .scaledToFit()
                                          .frame(height: 30)
                                          .padding(.leading, colorScheme == .dark ? 0:10)
                                      Spacer()
                                  }
                            
                              }
                          }
        }
        .padding()
    }
        
       
    
    func didDismiss() {
        viewModel.cancelResponseTask()
    }
    
    
}


#Preview {
    MeleeHelpView()
}
