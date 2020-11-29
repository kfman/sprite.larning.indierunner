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
    
    var touch = false
    var brake = false
    
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var gameState = GameState.ready{
        willSet{
            switch newValue {
            case .ongoing:
                player.state = .running
                pauseEnemies(bool: false)
            case .finished:
                player.state = .idle
                pauseEnemies(bool: true)
            default:
                break
            }
        }
    }
    
    var coins = 0
    var superCoins = 0

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx:0, dy: -6.0)
        
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x:frame.minX, y: frame.minY), to: CGPoint(x:frame.maxX, y: frame.minY))
        physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.frameCategorie
        physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.playerCategorie
        
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
            PhysicsHelper.addPhysicsBody(to: tileMap, and: "ground")
            
            for child in groundTile.children{
                if let sprite = child as? SKSpriteNode, sprite.name != nil{
                    ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
                }
            }
        }
        
        addPlayer()
    }
    
    func addPlayer(){
        player = Player(imageNamed: GameConstants.StringConstants.playerImageName)
        player.scale(to: frame.size, width: false, multiplier: 0.1)
        
        player.name = GameConstants.StringConstants.playerName
        PhysicsHelper.addPhysicsBody(to: player, with: player.name!)
        player.position = CGPoint(x: frame.midX/2, y: frame.midY)
        player.zPosition = GameConstants.ZPositions.playerZ
        player.loadTextures()
        player.state = .idle
        addChild(player)
        addPlayerActions()
    }
    
    func addPlayerActions(){
        let up = SKAction.moveBy(x: 0.0, y: frame.size.height / 4, duration: 0.4)
        up.timingMode = .easeOut
        
        player.createUserData(entry: up, forKey: GameConstants.StringConstants.jumpUpActionKey)
        
        let move = SKAction.moveBy(x: 0.0, y: player.size.height, duration: 0.4)
        let jump = SKAction.animate(with: player.jumpFrames, timePerFrame: 0.4/Double(player.jumpFrames.count))
        
        let group = SKAction.group([move, jump])
        
        player.createUserData(entry: group, forKey: GameConstants.StringConstants.brakeDescentActionKey)
    }
    
    func jump(){
        player.airborne = true
        player.turnGravity(on: false)
        player.run(player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey ) as! SKAction){
            if self.touch{
                self.player.run(self.player.userData?.value(forKey: GameConstants.StringConstants.jumpUpActionKey) as! SKAction, completion:{
                    self.player.turnGravity(on: true)
                })
            } else {
                self.player.turnGravity(on: true)
            }
        }
    }
    
    func brakeDescent(){
        brake = true
        player.physicsBody!.velocity.dy = 0.0
        
        if let brakeEffect = ParticleHelper.addParticleEffect(
            name: GameConstants.StringConstants.brakeEmitterKey,
            particlePositionRange: CGVector(dx:30.0, dy: 30.0),
            position: CGPoint(x: player.position.x, y: player.position.y - player.size.height / -2.0)){
            brakeEffect.zPosition = GameConstants.ZPositions.objectZ
            addChild(brakeEffect)
            
            
            player.run(
                player.userData?.value(forKey: GameConstants.StringConstants.brakeDescentActionKey) as! SKAction,
                completion: {
                    ParticleHelper.removeParticleEffect(name: GameConstants.StringConstants.brakeEmitterKey, from: self)
                    
                }
            )
        }
    }
    
    func handleEnemyContact(){
        die(reason: 0)
    }
    
    func handleCollectible(sprite: SKSpriteNode){
        switch sprite.name {
        case GameConstants.StringConstants.coinName:
            collectCoint(sprite: sprite)
        case _ where GameConstants.StringConstants.superCoinName.contains(sprite.name!):
            collectCoint(sprite: sprite)
        default:
            break
        }
    }

    func collectCoint(sprite: SKSpriteNode) {
        
        if GameConstants.StringConstants.superCoinName.contains(sprite.name!){
            superCoins += 1
        }else {
            coins += 1
        }
        
        if let coinDust = ParticleHelper.addParticleEffect(name: GameConstants.StringConstants.coinDustEmitterKey, particlePositionRange: CGVector(dx: 5.0, dy: 5.0), position: CGPoint.zero){
            coinDust.zPosition = GameConstants.ZPositions.objectZ
            sprite.addChild(coinDust)
            sprite.run(SKAction.fadeOut(withDuration: 0.4)){
                coinDust.removeFromParent()
                sprite.removeFromParent()
            }
        }
    }
    
    func die(reason: Int){
        gameState = .finished
        player.turnGravity(on: false)
        let deathAnimation: SKAction!
        
        switch reason{
        case 1:
            let up = SKAction.moveTo(y: frame.midY, duration: 0.25)
                up.timingMode = .easeOut
            let wait = SKAction.wait(forDuration: 0.1)
            let down = SKAction.moveTo(y: -player.size.height, duration: 0.2)
            deathAnimation = SKAction.sequence([up, wait, down])
        default:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        }
        
        player.run(deathAnimation){
            self.player.removeFromParent()
        }
        
    }
    
    func pauseEnemies(bool: Bool){
        for enemy in tileMap[GameConstants.StringConstants.enemyName]{
            enemy.isPaused = bool
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .ongoing
        case .ongoing:
            touch = true
            if !player.airborne{
                jump()
            }else if !brake {
                brakeDescent()
            }
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        //player.turnGravity(on: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        //player.turnGravity(on: true)
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
        
        self.isPaused = true
        self.isPaused = false
    }
    
    override func didSimulatePhysics() {
        for node in tileMap[GameConstants.StringConstants.groundNodeName]{
            if let groundNode = node as? GroundNode{
                let groundY = (groundNode.position.y + groundNode.size.height) * tileMap.yScale
                let playerY = player.position.y - player.size.height / 3
                
                groundNode.isBodyActivated = playerY > groundY
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask{
        case GameConstants.PhysicsCategories.playerCategorie | GameConstants.PhysicsCategories.groundCategorie:
            player.airborne = false
            brake = false
            
        case GameConstants.PhysicsCategories.playerCategorie | GameConstants.PhysicsCategories.finishCategorie:
            gameState = .finished
            
        case GameConstants.PhysicsCategories.playerCategorie | GameConstants.PhysicsCategories.enemyCategorie:
            handleEnemyContact()
        
        case GameConstants.PhysicsCategories.playerCategorie | GameConstants.PhysicsCategories.frameCategorie:
            physicsBody = nil
            die(reason: 1)

        case GameConstants.PhysicsCategories.playerCategorie | GameConstants.PhysicsCategories.collectableCategorie:
            let sprite = contact.bodyA.node?.name == GameConstants.StringConstants.coinName ? contact.bodyA.node : contact.bodyB.node
            handleCollectible(sprite: sprite as! SKSpriteNode)

        default:
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask{
        case GameConstants.PhysicsCategories.playerCategorie | GameConstants.PhysicsCategories.groundCategorie:
            player.airborne = true
        default:
            break
        }
    }
    
}

