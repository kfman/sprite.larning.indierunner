//
//  GameScene.swift
//  Super Indie Runner
//
//  Created by Klaus Fischer on 28.11.20.
//

import SpriteKit

class GameScene: SKScene {
    
    var worldLayer: Layer!
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        createLayers()
    }
    
    func createLayers(){
        worldLayer = Layer()
        addChild(worldLayer)
        
        worldLayer.layerVelocity = CGPoint(x: -200.0, y: 0.0)
        load(level: "Level_0-1")

    }
    
    func load(level: String){
        if let levelNode = SKNode.unarchiveFromFile(file: level){
            mapNode = levelNode
            worldLayer.addChild(mapNode)
            loadTileMap()
        }
    }
    
    func loadTileMap(){
        if let groundTile = mapNode.childNode(withName: "Ground Tiles") as? SKTileMapNode {
            tileMap = groundTile
            tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastTime > 0 {
            dt = currentTime - lastTime
        }
        else{
            dt = 0
        }
        lastTime = currentTime
        
        worldLayer.update(dt)
    }
}

