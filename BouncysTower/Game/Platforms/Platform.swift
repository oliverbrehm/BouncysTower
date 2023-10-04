//
//  Platform.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Platform: SKSpriteNode {
    static let height: CGFloat = 20
    
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
        backgroundColor: SKColor = SKColor.white,
        tileColor: SKColor? = nil)
    {
        self.level = level
        self.platformNumber = platformNumber
        self.backgroundColor = backgroundColor
        self.tileTexture = texture
        self.tileEndTexture = textureEnds
        self.platformNumberInLevel = platformNumberInLevel
                
        let platformHeight = Platform.height
        let nTiles = (width / platformHeight).rounded(.up)
        let platformSize = CGSize(width: nTiles * platformHeight, height: platformHeight)

        super.init(texture: nil, color: SKColor.clear, size: platformSize)
        
        initChildern(tileColor: tileColor)
        
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
        if ResourceManager.standard.consumeExtraLife() {
            let extraLife = ConsumableExtraLife()
            extraLife.position = getConsumableRandomPosition(forNode: extraLife)
            self.addChild(extraLife)
            return true
        }
        
        return false
    }
    
    func spawnSuperCoin() -> Bool {
        if ResourceManager.standard.consumeSuperCoin() {
            let superCoin = SuperCoin()
            superCoin.position = getConsumableRandomPosition(forNode: superCoin)
            self.addChild(superCoin)
            return true
        }
        
        return false
    }
    
    func spawnSuperJump() -> Bool {
        guard !isInTopPartOfLevel else { return false }
        
        if ResourceManager.standard.consumeSuperJump() {
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
        initChildern(tileColor: level.platformColor)
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
    
    private func initChildern(tileColor: SKColor?) {
        initPhysicsBody()
        initTiles(tileColor: tileColor)
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
        if platformNumber % 5 == 0, platformNumber >= 5 {
            let label = SKLabelNode(text: "\(platformNumber)")
            label.fontName = Font.fontName
            label.fontSize = 16.0
            label.fontColor = SKColor.white
            label.position = CGPoint(x: 0.0, y: -label.frame.size.height / 2.0)
            let container = SKShapeNode(rectOf: CGSize(width: label.frame.size.width + 2.0, height: label.frame.size.height + 2.0), cornerRadius: 5.0)
            container.fillColor = level.tintColor
            container.lineWidth = 3.0
            container.strokeColor = level.tintColor
            container.position = CGPoint(x: 0.0, y: -size.height * 0.5)
            container.addChild(label)
            container.zPosition = NodeZOrder.platformLabelContainer
            label.zPosition = 0.1 // relative to parent node
            self.addChild(container)
        }
    }
    
    private func initTiles(tileColor: SKColor?) {
        guard let tileTexture = tileTexture else { return }
        
        var x = -size.width / 2.0
        let w = size.height

        while x < size.width / 2.0 {
            let tile = SKSpriteNode(texture: tileTexture, size: CGSize(width: w, height: size.height))
            
            if let tileColor = tileColor {
                initColorAnimation(forTile: tile, withColor: tileColor)
            }
            
            let tileEndTexture = self.tileEndTexture ?? tileTexture
            
            if x < -size.width / 2.0 + w / 2.0 {
                tile.texture = tileEndTexture
            } else if x > size.width / 2.0 - 1.5 * w {
                tile.texture = tileEndTexture
                tile.xScale = -1
            }
            
            tile.position = CGPoint(x: x + w / 2.0, y: 0.0)
            self.addChild(tile)
            x += w
        }
    }
    
    private func initColorAnimation(forTile tile: SKSpriteNode, withColor color: SKColor) {
        if platformNumberInLevel >= 10 {
            let secondColor = platformNumber > 50 ? SKColor.random(excluding: color) : SKColor.white
                
            let intensity = Double(platformNumberInLevel - 10)
            let startAnimationTime = 2.0
            let minAnimationTime = 0.2
            let intensityFactor = 0.02
            let animationTime = max(minAnimationTime, startAnimationTime - intensity * intensityFactor)
            
            tile.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: animationTime / 2.0),
                SKAction.colorize(with: secondColor, colorBlendFactor: 1.0, duration: animationTime / 2.0)
            ])))
        } else {
            tile.colorBlendFactor = 1
            tile.color = color
        }
    }
}
