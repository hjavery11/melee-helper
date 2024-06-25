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
        
        enum MeleeMoves: String, CaseIterable {
            case uptilt = "Up Tilt"
            case downtilt = "Down Tilt"
            case forwardtilt = "Forward Tilt"
            case forwardtilt_down = "Forward Tilt Down"
            case forwardtilt_forward = "Forward Tilt Forward"
            case forwardtilt_up = "Forward Tilt Up"
            case upair = "Up Air"
            case downair = "Down Air"
            case forwardair = "Forward Air"
            case backair = "Back Air"
            case neutralair = "Neutral Air"
            case upsmash = "Up Smash"
            case downsmash = "Down Smash"
            case forwardsmash = "Forward Smash"
            case grab = "Grab"
            case dashgrab = "Dash Grab"
            case jab1 = "Jab 1"
            case jab2 = "Jab 2"
            case rapidjab = "Rapid Jab"
            case dashattack = "Dash Attack"
            case shield = "Shield"
            case rollforward = "Roll Forward"
            case rollback = "Roll Back"
            case spotdodge = "Spot Dodge"
            case airdodge = "Air Dodge"
            case specialneutral = "Special Neutral"
            case specialneutral_aerial = "Special Neutral Aerial"
            case specialup = "Special Up"
            case specialdown = "Special Down"
            case specialside = "Special Side"
            case specialside_aerial = "Special Side Aerial"
        }
    }
    
    init(name: String, imageName: String, description: String) {
        self.name = name
        self.imageName = imageName
        self.description = description
        
        self.moveSet = Move.MeleeMoves.allCases.map{ meleeMove in
            Move(moveName: "\(meleeMove.rawValue)", moveAnimationURL: "\(name)_\(meleeMove)")
        }
    }

    
    
   
}

