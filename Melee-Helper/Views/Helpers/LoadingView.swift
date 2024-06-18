//
//  LoadingView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/17/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView("Loading.....")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground).opacity(0.5))
            .ignoresSafeArea()
    }
}

#Preview {
    LoadingView()
}
