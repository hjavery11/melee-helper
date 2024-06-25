//
//  ContentView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI

struct MeleeHomeScreenView: View {
    
    @State private var selection: Tab = .homeview
    
    enum Tab {
        case gridview
        case imageview
        case homeview
        case postmatchview
    }
    
    var body: some View {
        TabView(selection: $selection){
            
            
          
            MeleeHelpView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.homeview)
            
            PostMatchView()
                .tabItem{
                    Label("Post-Match", systemImage: "gamecontroller")
                }
                .tag(Tab.postmatchview)
            
            
            MeleeCharacterGridView()
                .tabItem {
                    Label("Info", systemImage: "square.grid.3x3")

                }
                .tag(Tab.gridview)
            
            
//            MeleeImageView()
//                .tabItem{
//                    Label("Detect",systemImage: "camera.viewfinder")
//                }
//                .tag(Tab.imageview)
            
          
            
        }
        .tint(Color(.label))
        
        
        
    }
    
    
}
#Preview {
    MeleeHomeScreenView()
}


