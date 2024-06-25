//
//  MeleeImageView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI

struct MeleeImageView: View {
    
    @State private var detectedCharacter: Character? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                CameraView(detectedCharacter: $detectedCharacter)
                    .frame(maxWidth:.infinity, maxHeight: 400)
                    .padding(.top,25)
                   
                Spacer().frame(height:20)
            
                Text("Character is:")
                    .font(.largeTitle)
                if let character = detectedCharacter {
                    MeleeCharacterTitleView(character: character)
                }else {
                    Text("No character detected...")
                        .font(.body)
                }
                Spacer()
            }
            .navigationTitle("Image Detection")
        }
    }
}

#Preview {
    MeleeImageView()
}
