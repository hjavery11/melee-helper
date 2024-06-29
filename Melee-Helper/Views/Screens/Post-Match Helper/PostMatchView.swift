//
//  PostMatchView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/25/24.
//

import SwiftUI

struct PostMatchView: View {
    
    @State var responseString: String = ""
    
    var body: some View {
        Text(responseString)
            .task {
                await testGPT()
            }
    }
    
    
    
    
    private func testGPT() async {
      let response = try? await NetworkManager.shared.fetchCompletion()
        responseString = response?.choices[0].message.content ?? ""
     
    }
}

#Preview {
    PostMatchView()
}
