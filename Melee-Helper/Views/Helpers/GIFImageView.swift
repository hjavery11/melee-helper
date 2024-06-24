//
//  GIFImageView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/24/24.
//

import SwiftUI
import UIKit

struct GIFImageView: UIViewRepresentable {
    let imageName = "FoxDTiltSSBM"
    
    func makeUIView(context: Context) -> UIImageView {
        // Create the UIImageView
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // Set content mode
        
        // Load the GIF using UIImage
        if let gif = UIImage(named: imageName) {
            imageView.image = gif
            imageView.startAnimating()
        } else {
            print("Failed to load GIF image.")
        }
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        // ImageView update logic if needed
    }
}
