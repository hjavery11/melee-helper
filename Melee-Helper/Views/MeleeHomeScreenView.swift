//
//  ContentView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI

struct MeleeHomeScreenView: View {
    
    @State private var selection: Tab = .gridview
    
    enum Tab {
        case gridview
        case imageview
    }
    
    var body: some View {
        TabView(selection: $selection){
            
            MeleeCharacterGridView()
                .tabItem {
                    Label("Home", systemImage: "square.grid.3x3")

                }
                .tag(Tab.gridview)
                .toolbarBackground(Color.red, for: .tabBar)
            
            
            MeleeImageView()
                .tabItem{
                    Label("Detect",systemImage: "camera.viewfinder")
                }
                .tag(Tab.imageview)
            
                .toolbarColorScheme(.dark, for: .tabBar)
            
        }
        .tint(Color(.label))
        
        
        
    }
}
#Preview {
    MeleeHomeScreenView()
}


