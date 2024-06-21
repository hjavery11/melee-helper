//
//  HelpResponseView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/19/24.
//

import SwiftUI
import MarkdownUI

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
                    } else{
                        //  Text(viewModel.response)
                        Markdown(viewModel.response)
                    }
                  
                }
                .scrollDismissesKeyboard(.immediately)
                
            }
            .padding(.top,70)
            .padding(.bottom,20)
            .overlay(alignment: .topLeading) {
                GeometryReader { geometry in
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            XDismissButton()
                        }
                        Spacer()
                        
                        HStack {
                            if expandTextField {
                                TextField("Enter a follow-up question", text: $userQuestion, onEditingChanged: { editingChanged in
                                    if !editingChanged && userQuestion.isEmpty {
                                        withAnimation {
                                            expandTextField = false
                                        }
                                    }
                                })
                                .padding(.leading, 10)
                                .submitLabel(.search)
                                .disabled(viewModel.isLoading)
                                .focused($isFocused)
                                .keyboardType(.alphabet)
                                .autocorrectionDisabled()
                                .onSubmit {
                                    if !userQuestion.isEmpty{
                                        viewModel.getFollowUpResponse(followUpQuestion: userQuestion)
                                        userQuestion = ""
                                    }
                                }
                            }
                            
                            Button {
                                if expandTextField {
                                    if !userQuestion.isEmpty {
                                        viewModel.getFollowUpResponse(followUpQuestion: userQuestion)
                                        userQuestion = ""
                                    } else {
                                        withAnimation {
                                            expandTextField.toggle()
                                            isFocused = false
                                        }
                                    }
                                } else {
                                    withAnimation {
                                        expandTextField.toggle()
                                        isFocused = true
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
                        .padding(5)
                        .frame(width: expandTextField ? 300 : 44, alignment: .center)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .inset(by: 0.5)
                                .stroke(Color(.meleeOrange), lineWidth: expandTextField ? 1:0)
                        )
                        .transition(.move(edge: .trailing))
                        .opacity(viewModel.isLoading ? 0:1)
                    }
                }
                .frame(height: 50)
            }
        }
    }
}
    
    #Preview {
        HelpResponseView(viewModel: MeleeHelpViewModel())
    }
    
    
