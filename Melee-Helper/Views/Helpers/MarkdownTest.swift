//
//  MarkdownTest.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/21/24.
//

import SwiftUI
import MarkdownUI
struct MarkdownTest: View {
    var body: some View {
       Markdown("""
    # Fox vs Jigglypuff:
    ## Neutral Game
    
    This is a brief paragraph overview of Fox vs. jigglypuff neutral game designed to help give me an overview before diving into the specific examples.
    
    1. ### Dash Dance and Mix-Ups:
        - Point 1 about this
    
        - Point 2 about this
    
    2. ### Effective Use of Aerials:
        - Point 1
    
        - Point 2
    3. ### Up-tilt as an Anti-Air Tool:
        - Point 1
    
        - Point 2
    
    This is a final brief summary of all we talked about to help bring it home and digest all the content.
    """)
    }
}

#Preview {
    MarkdownTest()
}
