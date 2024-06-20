//
//  HelpResponseView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/19/24.
//

import SwiftUI

struct HelpResponseView: View {
    
    @ObservedObject var viewModel: MeleeHelpViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var userQuestion = ""
    
    private var shadowColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2)
    }
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: shadowColor, radius: 5, x: 0, y: 5)
            ScrollView{
                VStack{
                    if(viewModel.isLoading){
                        LoadingView()
                            .offset(y:250)
                    }
                    Text(viewModel.response)
                        .padding()
                }
            }
            
        }
        .padding(.top,70)
        .padding(.bottom,20)
        .overlay(alignment: .topLeading){
            HStack{
                Button{
                    dismiss()
                } label: {
                    XDismissButton()
                }
                Spacer()
                
                HStack{
                    TextField("Enter a follow-up question", text: $userQuestion)
                        .padding(.leading, 10)
                        .submitLabel(.search)
                    Button{
                       // viewModel.getResponse(userCharacter: <#T##String#>, enemyCharacter: <#T##String#>, helpType: <#T##String#>)
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .tint(Color(.label))
                    }
                    .keyboardShortcut(.defaultAction)
                    
                     
                      
                }
                .padding(10)
                .frame(width: 300, alignment: .center)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .inset(by: 0.5)
                        .stroke(Color(.meleeOrange), lineWidth: 1)
                )
            }
        }
        
        
        
        
    }
}

#Preview {
    HelpResponseView(viewModel: MeleeHelpViewModel())
}


