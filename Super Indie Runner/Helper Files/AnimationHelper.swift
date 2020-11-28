//
//  AnimationHelper.swift
//  Super Indie Runner
//
//  Created by Klaus Fischer on 28.11.20.
//

import SpriteKit

class AnimationHelper{
    
    static func loadTextures(from atlas: SKTextureAtlas, with name: String)->[SKTexture]{
        var textures = [SKTexture]()
        
        for index in 0..<atlas.textureNames.count{
            let textureName = name + String(index)
            textures.append(atlas.textureNamed(textureName))
        }
        return textures
    }
    
}
