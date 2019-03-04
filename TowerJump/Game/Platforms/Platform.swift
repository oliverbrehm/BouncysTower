//
//  Platform.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Platform: SKSpriteNode {
    static let height: CGFloat = 15.0
    
    let platformNumber: Int
    
    let level: Level
    
    let backgroundColor: SKColor
    
    init(width: CGFloat, texture: SKTexture?, level: Level, platformNumber: Int, backgroundColor: SKColor = SKColor.white) {
        self.level = level
        self.platformNumber = platformNumber
        self.backgroundColor = backgroundColor
        let platformSize = CGSize(width: width, height: Platform.height)

        super.init(texture: nil, color: SKColor.init(white: 0.0, alpha: 0.0), size: platformSize)
        
        self.physicsBody = SKPhysicsBody.init(rectangleOf: platformSize)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = NodeCategories.platform
        self.physicsBody?.contactTestBitMask = NodeCategories.platform | NodeCategories.player
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        ResourceManager.standard.advancePlatform()
        
        self.initTiles(platformSize: platformSize, texture: texture)
        
        if(platformNumber % 5 == 0) {
            let label = SKLabelNode(text: "\(platformNumber)")
            label.fontName = "AmericanTypewriter-Bold"
            label.fontSize = 16.0
            label.fontColor = SKColor.white
            label.position = CGPoint(x: 0.0, y: -label.frame.size.height)
            let container = SKSpriteNode(color: SKColor.brown,
                                         size: CGSize(width: label.frame.size.width + 2.0, height: label.frame.size.height + 2.0))
            container.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            container.addChild(label)
            container.zPosition = NodeZOrder.platformLabelContainer
            label.zPosition = NodeZOrder.platformLabel
            self.addChild(container)
        }
        
        // consumables
        self.spawnBrick()
        self.spawnExtraLife()
        
        self.zPosition = NodeZOrder.world
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.platformNumber = -1
        self.level = Level01(worldWidth: 0.0)
        self.backgroundColor = SKColor.white
        super.init(coder: aDecoder)
    }
    
    private func randomX(withOffset offset: CGFloat) -> CGFloat {
        let xRangeMin = -self.size.width / 2.0 + offset
        let xRangeMax = self.size.width / 2.0 - offset
        return CGFloat.random(in: xRangeMin ..< xRangeMax)
    }
    
    private func spawnBrick() {
        if let brick = ResourceManager.standard.consumeBrick() {
            let brickNode = ConsumableBrick(brick: brick)
            let y = self.size.height / 2.0 + brickNode.size.height / 2.0 + 5.0
            brickNode.position = CGPoint(x: self.randomX(withOffset: brickNode.size.width / 2.0), y: y)
            self.addChild(brickNode)
        }
    }
    
    private func spawnExtraLife() {
        if(ResourceManager.standard.consumeExtraLife()) {
            let extraLife = ConsumableExtraLife()
            let y = self.size.height / 2.0 + extraLife.size.height / 2.0 + 5.0
            extraLife.position = CGPoint(x: self.randomX(withOffset: extraLife.size.width / 2.0), y: y)
            self.addChild(extraLife)
        }
    }
    
    func setup() {
        // override in subclasses
    }
    
    func hitPlayer(player: Player, world: World) {
        self.level.reached = true
        // special behaviour in subclasses
    }
    
    func activateCollisions() {
        self.physicsBody?.categoryBitMask = NodeCategories.platform
        self.physicsBody?.contactTestBitMask = NodeCategories.platform | NodeCategories.player
    }
    
    func deactivateCollisions() {
        self.physicsBody?.categoryBitMask = NodeCategories.platformDeactivated
        self.physicsBody?.contactTestBitMask = NodeCategories.platformDeactivated
    }
    
    func score() -> Int {
        return 5
    }
    
    private func initTiles(platformSize: CGSize, texture: SKTexture?) {
        var x = -platformSize.width / 2.0
        while x <= platformSize.width / 2.0 {
            // TODO don't stretch texture of last tile but cut off/crop
            let remainingWidth = platformSize.width / 2.0 - x
            let w = min(remainingWidth, platformSize.height)
            let tile = SKSpriteNode(texture: texture, size: CGSize(width: w, height: platformSize.height))
            tile.position = CGPoint(x: x + w / 2.0, y: 0.0)
            self.addChild(tile)
            x += platformSize.height
        }
    }
}
