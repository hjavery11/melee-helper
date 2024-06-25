//
//  MeleeHomeScreenViewModel.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import Foundation
import SwiftUI

class MeleeCharacterGridViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    
    
    func testPath() {
        let fileManager = FileManager.default
        let resourcePath = Bundle.main.resourcePath!

        // First, try to list the contents of the "Gifs" folder
        let gifsPath = resourcePath + "/Gifs"
        do {
            let gifsContents = try fileManager.contentsOfDirectory(atPath: gifsPath)
            print("Contents of '/Gifs': \(gifsContents)")
        } catch {
            print("Error reading '/Gifs' directory: \(error)")
            
            // If failed, list the contents of the main bundle directory
            do {
                let bundleContents = try fileManager.contentsOfDirectory(atPath: resourcePath)
                print("Contents of the main bundle directory: \(bundleContents)")
            } catch {
                print("Error reading the main bundle directory: \(error)")
            }
        }
    }


    
}
