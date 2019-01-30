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
    
    public let Level : Level
    
    init(width : CGFloat, texture: SKTexture?, level: Level, platformNumber: Int, numberOfCoins: Int) {
        self.Level = level
        self.PlatformNumber = platformNumber
        let platformSize = CGSize(width: width, height: Platform.HEIGHT);

        super.init(texture: nil, color: SKColor.init(white: 0.0, alpha: 0.0), size: platformSize)
        
        self.physicsBody = SKPhysicsBody.init(rectangleOf: platformSize)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = NodeCategories.Platform
        self.physicsBody?.contactTestBitMask = NodeCategories.Platform | NodeCategories.Player;
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.initTiles(platformSize: platformSize, texture: texture);
        
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
            container.zPosition = NodeZOrder.PlatformLabelContainer
            label.zPosition = NodeZOrder.PlatformLabel
            self.addChild(container)
        }
        
        self.zPosition = NodeZOrder.World
        
        self.spawnCoins(platformSize: platformSize, n: numberOfCoins)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func spawnCoins(platformSize: CGSize, n: Int) {
        let coinPlatformMargin: CGFloat = 15.0
        let d = (platformSize.width - 2 * coinPlatformMargin) / CGFloat(n - 1)
        
        var x = -platformSize.width / 2.0 + coinPlatformMargin
        
        var i = 0
        while i < n {
            let coin = Coin()
            coin.position = CGPoint(x: x, y: platformSize.height / 2.0 + Coin.COIN_SIZE / 2.0 + 2.0)
            self.addChild(coin)
            
            x = x + d
            i = i + 1
        }
    }
    
    public func HitPlayer(player: Player) {
        self.Level.Reached = true
        // special behaviour in subclasses
    }
    
    public func ActivateCollisions() {
        self.physicsBody?.categoryBitMask = NodeCategories.Platform
        self.physicsBody?.contactTestBitMask = NodeCategories.Platform | NodeCategories.Player
    }
    
    public func DeactivateCollisions() {
        self.physicsBody?.categoryBitMask = NodeCategories.PlatformDeactivated
        self.physicsBody?.contactTestBitMask = NodeCategories.PlatformDeactivated
    }
    
    public func Score() -> Int {
        return 5
    }
    
    private func initTiles(platformSize: CGSize, texture: SKTexture?) {
        var x = -platformSize.width / 2.0
        while x <= platformSize.width / 2.0 {
            // TODO don't stretch texture of last tile but cut off/crop
            let remainingWidth = platformSize.width / 2.0 - x
            let w = min(remainingWidth, platformSize.height);
            let tile = SKSpriteNode(texture: texture, size: CGSize(width: w, height: platformSize.height))
            tile.position = CGPoint(x: x + w / 2.0, y: 0.0)
            self.addChild(tile)
            x += platformSize.height
        }
    }
}
