//
//  XDismissButton.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/20/24.
//

import SwiftUI
struct XDismissButton: View {
    var body: some View {
        ZStack {
            Image(systemName:"xmark")
                .imageScale(.large)
                .frame(width:44, height: 44)
                .tint(Color(.label))
        }
    }
}

#Preview {
    XDismissButton()
}
