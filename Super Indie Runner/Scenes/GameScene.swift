//
//  GameScene.swift
//  Super Indie Runner
//
//  Created by Klaus Fischer on 28.11.20.
//

import SpriteKit

enum GameState{
    case ready, ongoing, paused, finished
}

class GameScene: SKScene {
    
    var worldLayer: Layer!
    var backgroundLayer: RepeatingLayer!
    var mapNode: SKNode!
    var tileMap: SKTileMapNode!
    var player: Player!
    
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var gameState = GameState.ready
    
    override func didMove(to view: SKView) {
        createLayers()
    }
    
    func createLayers(){
        worldLayer = Layer()
        addChild(worldLayer)
        
        worldLayer.layerVelocity = CGPoint(x: -200.0, y: 0.0)
        
        backgroundLayer = RepeatingLayer()
        addChild(backgroundLayer)
        
        for i in 0...1 {
            let backgroundImage = SKSpriteNode(imageNamed: GameConstants.StringConstants.worldBackgroundNames[0])
            backgroundImage.name = String(i)
            backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0)
            backgroundImage.anchorPoint = CGPoint.zero
            backgroundImage.position = CGPoint(x: CGFloat(i) * backgroundImage.size.width, y: 0.0)
            backgroundLayer.addChild(backgroundImage)
        }
        backgroundLayer.layerVelocity = CGPoint(x: -100.0, y: 0.0)
        backgroundLayer.zPosition = GameConstants.ZPositions.farBGZ;
        
        worldLayer.zPosition = GameConstants.ZPositions.worldZ
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
        if let groundTile = mapNode.childNode(withName: GameConstants.StringConstants.groundTilesName) as? SKTileMapNode {
            tileMap = groundTile
            tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
        }
        
        addPlayer()
    }
    
    func addPlayer(){
        player = Player(imageNamed: GameConstants.StringConstants.playerImageName)
        player.scale(to: frame.size, width: false, multiplier: 0.1)
        
        player.name = GameConstants.StringConstants.playerName
        player.position = CGPoint(x: frame.midX/2, y: frame.midY)
        player.zPosition = GameConstants.ZPositions.playerZ

        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .ongoing
        default:
            gameState = .paused
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
        
        if gameState == .ongoing{
            worldLayer.update(dt)
            backgroundLayer.update(dt)
        }
    }
}

