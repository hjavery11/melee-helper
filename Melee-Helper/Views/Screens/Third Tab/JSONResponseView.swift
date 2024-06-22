//
//  JSONResponseView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/22/24.
//

import SwiftUI

struct JSONResponseView: View {
    let response: JSONResponse
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(response.title)
                    .font(.title)
                    .padding(.bottom, 5)
                
                Text(response.overview)
                    .font(.body)
                    .padding(.bottom, 10)
                
                ForEach(response.sections, id: \.title) { section in
                    SectionView(section: section)
                }
                
                Text(response.summary)
                    .font(.body)
                    .padding(.top, 10)
            }
            .padding()
        }
    }
}

struct SectionView: View {
    let section: JSONResponse.Section
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(section.title)
                .font(.headline)
            
            ForEach(section.points, id: \.self) { point in
                Text("- \(point)")
                    .font(.body)
            }
        }
        .padding(.bottom, 10)
    }
}
