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
    let platformNumberInLevel: Int
    
    let level: Level
    
    var nextPlatform: Platform?
    
    let backgroundColor: SKColor
    
    var tileTexture: SKTexture?
    var tileEndTexture: SKTexture?
    
    var isInTopPartOfLevel: Bool {
        return level.numberOfPlatforms - platformNumberInLevel < 20
    }
    
    init(
        width: CGFloat,
        texture: SKTexture?,
        textureEnds: SKTexture?,
        level: Level,
        platformNumber: Int,
        platformNumberInLevel: Int,
        backgroundColor: SKColor = SKColor.white)
    {
        self.level = level
        self.platformNumber = platformNumber
        self.backgroundColor = backgroundColor
        self.tileTexture = texture
        self.tileEndTexture = textureEnds
        self.platformNumberInLevel = platformNumberInLevel
                
        let nTiles = (width / Platform.height).rounded(.up)
        let platformSize = CGSize(width: nTiles * Platform.height, height: Platform.height)

        super.init(texture: nil, color: SKColor.clear, size: platformSize)
        
        initChildern()
        
        ResourceManager.standard.advancePlatform()
        
        if !isInTopPartOfLevel {
            ResourceManager.standard.advanceSuperJumpConsumable()
        }

        self.zPosition = NodeZOrder.world
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.platformNumber = -1
        self.platformNumberInLevel = -1
        self.level = LevelBase1(world: World())
        self.backgroundColor = SKColor.white
        super.init(coder: aDecoder)
    }

    private func randomX(withOffset offset: CGFloat) -> CGFloat {
        let xRangeMin = -self.size.width / 2.0 + offset
        let xRangeMax = self.size.width / 2.0 - offset
        return CGFloat.random(in: xRangeMin ..< xRangeMax)
    }
    
    func spawnBrick() -> Bool {
        if let brick = ResourceManager.standard.consumeBrick() {
            let brickNode = ConsumableBrick(brick: brick)
            brickNode.position = getConsumableRandomPosition(forNode: brickNode)
            self.addChild(brickNode)
            return true
        }
        
        return false
    }
    
    func spawnExtraLife() -> Bool {
        if(ResourceManager.standard.consumeExtraLife()) {
            let extraLife = ConsumableExtraLife()
            extraLife.position = getConsumableRandomPosition(forNode: extraLife)
            self.addChild(extraLife)
            return true
        }
        
        return false
    }
    
    func spawnSuperCoin() -> Bool {
        if(ResourceManager.standard.consumeSuperCoin()) {
            let superCoin = SuperCoin()
            superCoin.position = getConsumableRandomPosition(forNode: superCoin)
            self.addChild(superCoin)
            return true
        }
        
        return false
    }
    
    func spawnSuperJump() -> Bool {
        guard !isInTopPartOfLevel else { return false }
        
        if(ResourceManager.standard.consumeSuperJump()) {
            let superJump = SuperJump()
            superJump.hitAction = { [weak self] in
                if let game = self?.scene as? Game {
                    game.player.superJump()
                }
            }
            superJump.position = getConsumableRandomPosition(forNode: superJump)
            self.addChild(superJump)
            return true
        }
        
        return false
    }
    
    func setup() {
        // override in subclasses
    }
    
    func expand() {
        // expand platform over entier width (for respawn when using extra life)
        let expandedWidth = level.world.width * 0.8
        position = CGPoint(x: 0.0, y: position.y)
        size = CGSize(width: expandedWidth, height: size.height)
        
        removeAllChildren()
        initChildern()
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
    
    private func getConsumableRandomPosition(forNode node: SKSpriteNode) -> CGPoint {
        let y: CGFloat = self.size.height / 2.0 + node.size.height / 2.0 + 5.0
        return CGPoint(x: self.randomX(withOffset: node.size.width / 2.0), y: y)
    }
    
    private func initChildern() {
        initPhysicsBody()
        initTiles()
        initNumberBadge()
    }
    
    private func initPhysicsBody() {
        self.physicsBody = SKPhysicsBody.init(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = NodeCategories.platformDeactivated
        self.physicsBody?.contactTestBitMask = NodeCategories.platformDeactivated
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    private func initNumberBadge() {
        if(platformNumber % 5 == 0) {
            let label = SKLabelNode(text: "\(platformNumber)")
            label.fontName = Font.fontName
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
    }
    
    private func initTiles() {
        guard let tileTexture = tileTexture else { return }
        
        var x = -size.width / 2.0
        let w = size.height

        while x < size.width / 2.0 {
            let tile = SKSpriteNode(texture: tileTexture, size: CGSize(width: w, height: size.height))
            
            let tileEndTexture = self.tileEndTexture ?? tileTexture
            
            if(x < -size.width / 2.0 + w / 2.0) {
                tile.texture = tileEndTexture
            } else if(x > size.width / 2.0 - 1.5 * w) {
                tile.texture = tileEndTexture
                tile.xScale = -1
            }
            
            tile.position = CGPoint(x: x + w / 2.0, y: 0.0)
            self.addChild(tile)
            x += w
        }
    }
}
