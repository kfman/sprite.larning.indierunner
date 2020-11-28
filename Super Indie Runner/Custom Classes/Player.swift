//
//  Player.swift
//  Super Indie Runner
//
//  Created by Klaus Fischer on 28.11.20.
//

import SpriteKit

enum PlayerState{
    case idle, running
}

class Player: SKSpriteNode {
    
    var runFrames = [SKTexture]()
    var idleFrames = [SKTexture]()
    var jumpFrames = [SKTexture]()
    var dieFrames = [SKTexture]()
    
    var state = PlayerState.idle{
        willSet{
            animate(for: newValue)
        }
    }
    
    func loadTextures(){
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerIdleAtlas), with: GameConstants.StringConstants.idlePrefixKey)
        
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerRunAtlas), with: GameConstants.StringConstants.runPrefixKey)

        jumpFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerJumpAtlas), with: GameConstants.StringConstants.jumpPrefixKey)
        
        dieFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.StringConstants.playerDieAtlas), with: GameConstants.StringConstants.diePrefixKey)
    }
    
    func animate(for state: PlayerState){
        removeAllActions()
        
        switch state {
        case .idle:
            self.run(SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.05, resize: true, restore: true)))
        case .running:
            self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05, resize: true, restore: true)))
        }
    }
    
}
