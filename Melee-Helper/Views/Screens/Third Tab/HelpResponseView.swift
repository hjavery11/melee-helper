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
    @State private var expandTextField = false
    @FocusState private var isFocused
    
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
            .scrollDismissesKeyboard(.immediately)
            
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
                
                
                if(!expandTextField && !viewModel.isLoading){
                    Button{
                        withAnimation{
                            expandTextField.toggle()
                            isFocused = true
                        }
                       
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .tint(Color(.label))
                            .imageScale(.large)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .padding(10)
                    }
                }
                if(expandTextField){
                    HStack{
                        TextField("Enter a follow-up question", text: $userQuestion, onEditingChanged: {(editingChanged) in
                            if editingChanged {
                                //focused
                               
                            } else {
                                //focus lost
                                withAnimation{
                                    expandTextField = false
                                }
                            }
                        })
                            .padding(.leading, 10)
                            .submitLabel(.search)
                            .disabled(viewModel.isLoading)
                            .focused($isFocused)
                        Button{
                            if !userQuestion.isEmpty {
                                viewModel.response = ""
                                viewModel.getFollowUpResponse(followUpQuestion: userQuestion)
                                userQuestion = ""
                            } else {
                                withAnimation{
                                    expandTextField.toggle()
                                    isFocused = false
                                }
                            }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .tint(Color(.label))
                                .imageScale(.large)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
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
                    .transition(.move(edge: .trailing))
                }
               
            }
        }
        
        
        
        
    }
}

#Preview {
    HelpResponseView(viewModel: MeleeHelpViewModel())
}


