//
//  CameraView.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
  
    @Binding var detectedCharacter: Character?
    
    
    func makeUIViewController(context: Context) -> CameraViewController {
        CameraViewController(cameraVCDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(cameraView: self)
    }
    
    final class Coordinator: NSObject, CameraVCDelegate {
        func didSurface(error: CameraError) {
            print("error")
        }
        
        private let cameraView: CameraView
        
        init(cameraView: CameraView) {
            self.cameraView = cameraView
        }
        
        func didFind(character: Character) {
            cameraView.detectedCharacter = character
        }
        
    
        
        
    }
    
    
}

#Preview {
    CameraView(detectedCharacter: .constant(CharacterData.allCharacters.first!))
}
