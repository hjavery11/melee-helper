//
//  JSONResponseView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/22/24.
//

import SwiftUI

struct JSONResponseView: View {
    let response: JSONResponse
    let clickFunction: (String) -> Void
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                if response.title != nil {
                    Text(response.title!)
                        .font(.title)
                        .padding(.bottom, 5)
                }
                
                if response.subtitle != nil {
                    Text(response.subtitle!)
                        .font(.title2)
                        .italic()
                }
                
              
                    Text(response.overview)
                        .font(.body)
                        .padding(.bottom, 10)
          
                
                if response.sections != nil {
                    ForEach(Array(response.sections!.enumerated()), id: \.element.title) { index, section in
                        SectionView(section: section, sectionNumber: index + 1, clickFunction: clickFunction)
                    }
                }
                
                if response.summary != nil {
                    Text("Summary:")
                        .font(.title2)
                        .underline()
                    Text(response.summary!)
                        .font(.body)
                        .padding(.top, 10)
                }
            }
            .padding()
    }
}

struct SectionView: View {
    let section: JSONResponse.Section
    let sectionNumber: Int
    let clickFunction: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Button{
                clickFunction(section.title)
            } label: {
                Text("\(sectionNumber). \(section.title)")
                    .underline()
                    .font(.headline)
                    .foregroundStyle(.link)
                    
            }
            
            ForEach(section.points, id: \.self) { point in
                Text("- \(point)")
                    .font(.body)
            }
        }
        .padding(.bottom, 10)
    }
}
