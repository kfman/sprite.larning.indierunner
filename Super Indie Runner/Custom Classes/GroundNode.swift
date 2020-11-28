//
//  GroundNode.swift
//  Super Indie Runner
//
//  Created by Klaus Fischer on 28.11.20.
//

import SpriteKit

class GroundNode: SKSpriteNode {

    var isBodyActivated: Bool = false{
        didSet{
            physicsBody = isBodyActivated ? activatedBody : nil
        }
    }
    
    private var activatedBody : SKPhysicsBody?
    
    init(with size: CGSize){
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        let bodyInitialPoint = CGPoint(x: 0.0, y: size.height)
        let bodyEndPoint = CGPoint(x: size.width, y:size.height)
        
        activatedBody = SKPhysicsBody(edgeFrom: bodyInitialPoint, to: bodyEndPoint)
        activatedBody!.restitution = 0.0
        activatedBody!.categoryBitMask = GameConstants.PhysicsCategories.groundCategorie
        activatedBody!.collisionBitMask = GameConstants.PhysicsCategories.playerCategorie
        
        physicsBody = isBodyActivated ? activatedBody : nil
        
        name = GameConstants.StringConstants.groundNodeName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
