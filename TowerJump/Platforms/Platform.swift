//
//  Platform.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Platform : SKSpriteNode
{
    public static let HEIGHT : CGFloat = 15.0;
    
    public let PlatformNumber : Int
    
    private let level : Level
    
    init(width : CGFloat, color: SKColor, level: Level, platformNumber: Int) {
        self.level = level
        self.PlatformNumber = platformNumber
        
        super.init(texture: nil, color: color, size: CGSize(width: width, height: Platform.HEIGHT))
        
        self.physicsBody = SKPhysicsBody.init(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = NodeCategories.Platform
        self.physicsBody?.contactTestBitMask = NodeCategories.Platform | NodeCategories.Player;
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        if(platformNumber % 5 == 0) {
            let label = SKLabelNode(text: "\(platformNumber)")
            label.fontSize = 20.0
            label.fontColor = SKColor.white
            label.position = CGPoint(x: 0.0, y: -label.frame.size.height)
            let container = SKSpriteNode(color: SKColor.brown,
                                         size: CGSize(width: label.frame.size.width + 2.0, height: label.frame.size.height + 2.0))
            container.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            container.addChild(label)
            self.addChild(container)
        }
        
        self.zPosition = NodeZOrder.World
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func HitPlayer(player: Player) {
        self.level.Reached = true
        // special behaviour in subclasses
    }
    
    public func ActivateCollisions() {
        self.physicsBody?.categoryBitMask = NodeCategories.Platform
        self.physicsBody?.contactTestBitMask = NodeCategories.Platform | NodeCategories.Player
    }
    
    public func DeactivateCollisions() {
        self.physicsBody?.categoryBitMask = 0x0
        self.physicsBody?.contactTestBitMask = 0x0
    }
}
