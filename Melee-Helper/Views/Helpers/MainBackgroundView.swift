//
//  MainBackgroundView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI
//stopped using this view because it looked ugly, but going to keep code just in case
struct MainBackgroundView: View {
    var body: some View {
        LinearGradient(colors: [Color("meleeRed"),Color("meleeOrange"),Color("meleeYellow")], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
    MainBackgroundView()
}
