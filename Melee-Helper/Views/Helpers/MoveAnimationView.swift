//
//  MoveAnimationView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/25/24.
//

import SwiftUI
import Kingfisher


struct MoveAnimationView: View {
    let gifURL: String
    
    var body: some View {
        VStack(spacing:20) {
          
            // Create a URL from the optional path
            if let path = Bundle.main.path(forResource: gifURL.lowercased(), ofType: "gif"),
               let _ = URL(string: path) {  // Ensure URL is valid
                KFAnimatedImage(URL(filePath: path))
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            } else {
                EmptyView()  // This will show nothing if the GIF does not exist
            }
        }
    }
}


#Preview {
    MoveAnimationView(gifURL: CharacterData.allCharacters[5].moveSet[5].moveAnimationURL)
    
}
