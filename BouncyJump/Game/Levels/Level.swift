//
//  Level.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Level: SKNode, LevelConfiguration {
    private var platformY: CGFloat
    private var backgroundY: CGFloat
    private var worldWidth: CGFloat
    
    private var platforms: [Platform] = []
    private let maxPlatforms = 25
    private var wallY: CGFloat = 0.0
    private var wallTiles: [SKSpriteNode] = []
    private let maxWallTiles = 250
    
    private var levelPlatformIndex = 1
    private var speedEaseIn: CGFloat = 999999999.0
    private var lastPlatform: Platform?
    
    var texturePlatform: SKTexture?
    var wallLeftTexture: SKTexture?
    var wallRightTexture: SKTexture?
    
    private let backgroundHeight: CGFloat = 500.0
    
    var reached = false
    
    init(worldWidth: CGFloat) {
        self.worldWidth = worldWidth
        backgroundY = 0.0
        platformY = 0.0
        super.init()
        
        self.platformY = self.firstPlatformOffset
        self.spawnBackground(above: backgroundHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backgroundColor: SKColor {
        return SKColor.black
    }
    
    var platformMinFactor: CGFloat {
        return 0.01
    }
    
    var platformMaxFactor: CGFloat {
        return 1.0
    }
    
    var platformYDistance: CGFloat {
        return 110.0
    }
    
    var numberOfPlatforms: Int {
        return 50
    }
    
    var levelSpeed: CGFloat {
        return 1.0
    }
    
    var firstPlatformOffset: CGFloat {
        return 600.0
    }
    
    func removeAllPlatforms() {
        for node in self.platforms {
            node.removeFromParent()
        }
        self.platforms.removeAll()
    }
    
    func reset() {
        self.levelPlatformIndex = 1
        self.platformY = 0.0
    }
    
    var topPlatformY: CGFloat {
        return platforms.last?.position.y ?? 0.0
    }
    
    var isLastPlatform: Bool {
        return self.levelPlatformIndex == self.numberOfPlatforms
    }
    
    var isFinished: Bool {
        return self.levelPlatformIndex > self.numberOfPlatforms
    }
    
    var gameSpeed: CGFloat {
        return min(self.speedEaseIn, self.levelSpeed)
    }
    
    var platformTexture: SKTexture? {
        return self.texturePlatform
    }
    
    func getPlatform(platformNumber: Int, yDistance: CGFloat = -1.0) -> Platform? {
        if(self.isFinished) {
            return nil
        }
        
        if(yDistance < 0) {
            platformY += self.platformYDistance
        } else {
            platformY += yDistance
        }
                
        let levelWidth = worldWidth - 2 * World.wallWidth
        
        // TODO replace with Double.random in Swift 4.2
        var x: CGFloat = 0.0
        
        var platform: Platform?
        
        if(self.isLastPlatform) {
            platform = EndLevelPlatform(
                width: worldWidth,
                texture: nil,
                level: self,
                platformNumber: platformNumber,
                backgroundColor: self.backgroundColor)
            self.spawnBackground(above: platformY)
        } else {
            let minWidth = levelWidth * self.platformMinFactor
            let maxWidth = levelWidth * self.platformMaxFactor
            
            let w = CGFloat.random(in: minWidth ..< maxWidth)
            x = CGFloat.random(in: -levelWidth / 2.0 + w / 2.0
                ..< levelWidth / 2.0 - w / 2.0)
            platform = StandardPlatform(width: w, texture: self.platformTexture, level: self, platformNumber: platformNumber)
            self.spawnBackground(above: platformY)
        }

        platform!.position = CGPoint(x: x, y: platformY)
        return platform!
    }
    
    func spawnBackground(above y: CGFloat) {
        let texture = SKTexture(imageNamed: "bg")
        let size = CGSize(width: self.worldWidth, height: self.worldWidth * texture.size().height / texture.size().width)
        
        while(self.backgroundY < y + 2 * size.height) {
            // get sub texture and size that fits exactly
            /*
            let textureHeight = heightLeft / size.height
            size.height = heightLeft
            texture = SKTexture(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 1.0, height: textureHeight)), in: texture)
            */
            
            let background = SKSpriteNode(texture: texture, color: self.backgroundColor, size: size)
            background.colorBlendFactor = 1.0
            background.position = CGPoint(x: 0.0, y: self.backgroundY + size.height / 2.0)
            background.zPosition = NodeZOrder.background
            
            self.addChild(background)
            
            self.backgroundY += size.height
        }        
    }
    
    func spawnWallTilesForPlatform(platform: Platform) {
        self.spawnWallTiles(above: platform.position.y)
    }
    
    func spawnWallTiles(above y: CGFloat) {
        let texL = self.wallLeftTexture
        let texR = self.wallRightTexture
        
        while(self.wallY <= y + 2 * self.worldWidth) {
            let left = SKSpriteNode(texture: texL, color: SKColor.white, size: CGSize(width: World.wallWidth, height: World.wallWidth))
            left.zPosition = NodeZOrder.world
            let right = SKSpriteNode(texture: texR, color: SKColor.white, size: CGSize(width: World.wallWidth, height: World.wallWidth))
            right.zPosition = NodeZOrder.world
            
            self.addChild(left)
            self.addChild(right)
            
            self.wallTiles.append(left)
            self.wallTiles.append(right)
            
            left.position = CGPoint(x: -worldWidth / 2.0 + World.wallWidth / 2.0, y: self.wallY)
            right.position = CGPoint(x: worldWidth / 2.0 - World.wallWidth / 2.0, y: self.wallY)
            
            self.wallY += World.wallWidth
        }
        
        while(self.wallTiles.count > maxWallTiles) {
            self.wallTiles.first?.removeFromParent()
            self.wallTiles.removeFirst()
        }
    }
    
    func updateCollisionTests(player: Player) {
        if(player.state == .falling) {
            for platform in platforms {
                let playerBottom =  self.convert(player.position, from: player.world!).y - player.size.height / 2.0
                if(playerBottom > platform.top() - 3.5) {
                    platform.activateCollisions()
                } else {
                    platform.deactivateCollisions()
                }
            }
        } else if(player.state == .jumping) {
            for platform in platforms {
                platform.deactivateCollisions()
            }
        }
    }
    
    func spawnPlatform(scene: Game, number: Int, numberOfCoins: Int? = nil, yDistance: CGFloat = -1.0) {
        self.levelPlatformIndex += 1
        
        if let platform = self.getPlatform(platformNumber: number, yDistance: yDistance) {
            self.addChild(platform)
            self.platforms.append(platform)
            platform.setup()
            
            if(self.platforms.count > self.maxPlatforms) {
                self.platforms.removeFirst().removeFromParent()
            }
            
            let n = numberOfCoins ?? ResourceManager.standard.consumeCoins()
            let platformSize = CGSize(width: platform.size.width, height: Platform.height)
            let platformInWorld = self.convert(platform.position, to: scene.world)
            let coinPlatformMargin: CGFloat = platformSize.width * 0.175
            scene.world.coinManager.spawnHorizontalLine(
                origin: CGPoint(x: platformInWorld.x, y: platformInWorld.y + platformSize.height / 2.0 + Coin.size / 2.0 + 2.0),
                width: platformSize.width - 2 * coinPlatformMargin, n: n)
            
            platform.deactivateCollisions()
            
            self.spawnWallTilesForPlatform(platform: platform)
        }
    }
    
    func fadeIn() {
        self.alpha = 0.0
        self.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    func fadeOutAndRemove() {
        self.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
        ]))
    }
    
    func easeInSpeed() {
        self.speedEaseIn = 0.0
        
        let easeInDuration = 5.0 // seconds
        let easeInStepTime = 0.25 // seconds
        let n = Int(easeInDuration / easeInStepTime)
        let easeInStep = self.levelSpeed / CGFloat(n)

        self.run(SKAction.repeat(SKAction.sequence([
            SKAction.wait(forDuration: easeInStepTime),
            SKAction.run {
                self.speedEaseIn += easeInStep
            }
        ]), count: n))
    }
}
