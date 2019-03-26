//
//  Platform.swift
//  BouncyJump
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
    
    init(width: CGFloat, texture: SKTexture?, textureEnds: SKTexture?, level: Level, platformNumber: Int, backgroundColor: SKColor = SKColor.white) {
        self.level = level
        self.platformNumber = platformNumber
        self.backgroundColor = backgroundColor
        
        let nTiles = (width / Platform.height).rounded(.up)
        let platformSize = CGSize(width: nTiles * Platform.height, height: Platform.height)

        super.init(texture: nil, color: SKColor.clear, size: platformSize)
        
        self.physicsBody = SKPhysicsBody.init(rectangleOf: platformSize)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = NodeCategories.platform
        self.physicsBody?.contactTestBitMask = NodeCategories.platform | NodeCategories.player
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        ResourceManager.standard.advancePlatform()
        
        self.initTiles(platformSize: platformSize, texture: texture, textureEnds: textureEnds)
        
        if(platformNumber % 5 == 0) {
            let label = SKLabelNode(text: "\(platformNumber)")
            label.fontName = Constants.fontName
            label.fontSize = 16.0
            label.fontColor = SKColor.white
            label.position = CGPoint(x: 0.0, y: -label.frame.size.height)
            let container = SKSpriteNode(color: SKColor.brown,
                                         size: CGSize(width: label.frame.size.width + 2.0, height: label.frame.size.height + 2.0))
            container.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            container.addChild(label)
            container.zPosition = NodeZOrder.platformLabelContainer
            label.zPosition = 0.1 // relative to parent node
            self.addChild(container)
        }

        self.zPosition = NodeZOrder.world
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.platformNumber = -1
        self.level = Level01(world: World())
        self.backgroundColor = SKColor.white
        super.init(coder: aDecoder)
    }
    
    private func randomX(withOffset offset: CGFloat) -> CGFloat {
        let xRangeMin = -self.size.width / 2.0 + offset
        let xRangeMax = self.size.width / 2.0 - offset
        return CGFloat.random(in: xRangeMin ..< xRangeMax)
    }
    
    func spawnBrick() {
        if let brick = ResourceManager.standard.consumeBrick() {
            let brickNode = ConsumableBrick(brick: brick)
            let y = self.size.height / 2.0 + brickNode.size.height / 2.0 + 5.0
            brickNode.position = CGPoint(x: self.randomX(withOffset: brickNode.size.width / 2.0), y: y)
            self.addChild(brickNode)
        }
    }
    
    func spawnExtraLife() {
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
        return 1
    }
    
    private func initTiles(platformSize: CGSize, texture: SKTexture?, textureEnds: SKTexture?) {
        var x = -platformSize.width / 2.0
        let w = platformSize.height

        while x < platformSize.width / 2.0 {
            let tile = SKSpriteNode(texture: texture, size: CGSize(width: w, height: platformSize.height))
            
            if let t = textureEnds {
                if(x < -platformSize.width / 2.0 + w / 2.0) {
                    tile.texture = t
                } else if(x > platformSize.width / 2.0 - 1.5 * w) {
                    tile.texture = t
                    tile.xScale = -1
                }
            }
            
            tile.position = CGPoint(x: x + w / 2.0, y: 0.0)
            self.addChild(tile)
            x += w
        }
    }
}
