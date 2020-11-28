//
//  GameConstants.swift
//  Super Indie Runner
//
//  Created by Klaus Fischer on 28.11.20.
//

import Foundation
import CoreGraphics

struct GameConstants{
    
    struct PhysicsCategories{
        static let noCategorie : UInt32 = 0
        static let allCategorie: UInt32 = UInt32.max
        
        static let playerCategorie : UInt32 = 0x01
        static let groundCategorie : UInt32 = 0x02
        static let finishCategorie: UInt32 = 0x04
        static let collectableCategorie : UInt32 = 0x08
        static let enemyCategorie : UInt32 = 0x10
        static let frameCategorie : UInt32 = 0x20
        static let ceilingCategorie : UInt32 = 0x40
    }
    
    
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
        static let finishLineName = "Finish Line"
        static let enemyName = "Enemy"
        static let coinName = "Coin"
        static let coinImageName = "gold0"
        
        static let playerIdleAtlas = "Player Idle Atlas"
        static let playerRunAtlas = "Player Run Atlas"
        static let playerJumpAtlas = "Player Jump Atlas"
        static let playerDieAtlas = "Player Die Atlas"
        static let coinRotateAtlas = "Coin Rotate Atlas"
        
        static let idlePrefixKey = "Idle_"
        static let runPrefixKey = "Run_"
        static let jumpPrefixKey = "Jump_"
        static let diePrefixKey = "Die_"
        static let coinPrefixKey = "gold"
        
        static let jumpUpActionKey = "JumpUp"
        static let brakeDescentActionKey = "BrakeDescent"
        
        static let coinDustEmitterKey = "CoinDustEmitter"
        static let brakeEmitterKey = "BrakeEmitter"
    }
    
}
