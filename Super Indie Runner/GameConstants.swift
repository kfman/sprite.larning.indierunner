//
//  GameConstants.swift
//  Super Indie Runner
//
//  Created by Klaus Fischer on 28.11.20.
//

import Foundation
import CoreGraphics

struct GameConstants{
    
    struct ZPositions{
        static let farBGZ: CGFloat = 0
        static let closeBGZ: CGFloat = 1
        static let worldZ: CGFloat = 2
        static let objectZ: CGFloat = 3
        static let playerZ: CGFloat = 4
        static let hudZ: CGFloat = 5
    }
    
    struct StringConstants{
        static let groundTilesName = "Ground Tiles"
        static let worldBackgroundNames = ["DessertBackground", "GrassBackground"]
        static let playerName = "Player"
        static let playerImageName = "Idle_0"
        static let groundNodeName = "GroundNode"
    }
    
}
