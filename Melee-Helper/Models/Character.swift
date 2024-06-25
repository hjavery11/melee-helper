//
//  Character.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/13/24.
//

import Foundation
import UIKit

struct Character:Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
    var moveSet: [Move]
    
  
    
    struct Move: Identifiable, Hashable {
        let id = UUID()
        let moveName: String
        let moveAnimationURL: String
        
        enum MeleeMoves: CaseIterable {
            case uptilt
            case downtilt
            case forwardtilt
            case forwardtilt_down
            case forwardtilt_forward
            case forwardtilt_up
            case upair
            case downair
            case forwardair
            case backair
            case neutralair
            case upsmash
            case downsmash
            case forwardsmash
            case grab
            case dashgrab
            case jab1
            case jab2
            case rapidjab
            case dashattack
            case shield
            case rollforward
            case rollback
            case spotdodge
            case airdodge
            case specialneutral
            case specialneutral_aerial
            case specialup
            case specialdown
            case specialside
            case specialside_aerial
        }
    }
    
    init(name: String, imageName: String, description: String) {
        self.name = name
        self.imageName = imageName
        self.description = description
        
        self.moveSet = Move.MeleeMoves.allCases.map{ meleeMove in
            Move(moveName: "\(meleeMove)", moveAnimationURL: "\(name)_\(meleeMove)")
        }
    }

    
    
   
}

