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
                
                
                
                
                Picker("Help", selection: $viewModel.helpType){
                    ForEach(HelpType.allCases) { helpType in
                        Text(helpType.rawValue.capitalized)
                        
                    }
                }
                .pickerStyle(.segmented)
                
              
                
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
            .navigationTitle("Melee AI Helper")
          

            
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
