//
//  Level.swift
//  TowerJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Level: SKNode
{
    private var platformY : CGFloat
    private var backgroundY: CGFloat
    private var worldWidth : CGFloat
    
    private var Platforms: [Platform] = []
    private var wallY: CGFloat = 0.0
    private var wallTiles: [SKSpriteNode] = []
    
    private var levelPlatformIndex = 0
    private var easeInSpeed: CGFloat = 999999999.0
    private var lastPlatform : Platform?
    
    var platformTexture : SKTexture?
    var wallLeftTexture: SKTexture?
    var wallRightTexture: SKTexture?
    
    private let BACKGROUND_HEIGHT:CGFloat = 500.0
    private let MAX_WALL_TILES = 150
    
    private var reached : Bool = false
    public var Reached : Bool
    {
        get {
            return reached
        }
        
        set {
            reached = newValue
        }
    }
    
    public static func RandomNumber(between a : CGFloat, and b: CGFloat) -> CGFloat
    {
        let r = arc4random_uniform(UInt32(b - a))
        return CGFloat(r) + a
    }
    
    init(worldWidth: CGFloat) {
        self.worldWidth = worldWidth
        platformY = 0.0
        backgroundY = 0.0
        super.init()
        
        self.SpawnBackground(beneath: BACKGROUND_HEIGHT)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func RemoveAllPlatforms() {
        for node in self.Platforms {
            node.removeFromParent()
        }
        self.Platforms.removeAll()
    }
    
    func BackgroundColor() -> SKColor {
        return SKColor.black
    }
    
    func Reset() {
        self.levelPlatformIndex = 0
        self.platformY = 0.0
    }
    
    func GetPlatform(platformNumber: Int, yDistance: CGFloat = -1.0) -> Platform {
        if(yDistance < 0) {
            platformY += self.PlatformYDistance()
        } else {
            platformY += yDistance
        }
                
        let levelWidth = worldWidth - 2 * World.WALL_WIDTH
        
        // TODO replace with Double.random in Swift 4.2
        var x: CGFloat = 0.0
        
        var platform : Platform? = nil
        
        if(self.IsFinished()) {
            platform = PlatformEndLevel(width: worldWidth, texture: nil, level: self, platformNumber: platformNumber)
        } else {
            let minWidth = levelWidth * self.PlatformMinFactor()
            let maxWidth = levelWidth * self.PlatformMaxFactor()
            
            let w = Level.RandomNumber(between: minWidth, and: maxWidth)
            x = Level.RandomNumber(
                between: -levelWidth / 2.0 + w / 2.0,
                and: levelWidth / 2.0 - w / 2.0)
            platform = Platform(width: w, texture: self.PlatformTexture(), level: self, platformNumber: platformNumber)
        }

        platform!.position = CGPoint(x: x, y: platformY)
        
        self.SpawnBackground(beneath: platformY)
        
        return platform!
    }
    
    func SpawnBackground(beneath y:CGFloat) {
        let texture = SKTexture(imageNamed: "bg")
        let size = CGSize(width: self.worldWidth, height: self.worldWidth * texture.size().height / texture.size().width)
        
        while(self.backgroundY < y + size.height / 2.0) {
            let background = SKSpriteNode(texture: texture, color: self.BackgroundColor(), size: size)
            background.colorBlendFactor = 1.0
            background.position = CGPoint(x: 0.0, y: self.backgroundY + size.height / 2.0)
            background.zPosition = NodeZOrder.Background
            self.addChild(background)
            self.backgroundY = self.backgroundY + size.height
        }        
    }
    
    public func SpawnWallTilesForPlatform(platform: Platform)
    {
        self.SpawnWallTiles(beneath: platform.position.y)
    }
    
    public func SpawnWallTiles(beneath y: CGFloat) {
        let texL = self.wallLeftTexture
        let texR = self.wallRightTexture
        
        while(self.wallY <= y) {
            let left = SKSpriteNode(texture: texL, color: SKColor.white, size: CGSize(width: World.WALL_WIDTH, height: World.WALL_WIDTH))
            left.zPosition = NodeZOrder.World
            let right = SKSpriteNode(texture: texR, color: SKColor.white, size: CGSize(width: World.WALL_WIDTH, height: World.WALL_WIDTH))
            right.zPosition = NodeZOrder.World
            
            self.addChild(left)
            self.addChild(right)
            
            self.wallTiles.append(left)
            self.wallTiles.append(right)
            
            left.position = CGPoint(x: -worldWidth / 2.0 + World.WALL_WIDTH / 2.0, y: self.wallY)
            right.position = CGPoint(x: worldWidth / 2.0 - World.WALL_WIDTH / 2.0, y: self.wallY)
            
            self.wallY += World.WALL_WIDTH
        }
        
        while(self.wallTiles.count > MAX_WALL_TILES) {
            self.wallTiles.first?.removeFromParent()
            self.wallTiles.removeFirst()
        }
    }
    
    public func UpdateCollisionTests(player : Player)
    {
        if(player.State == .Falling)
        {
            for platform in Platforms
            {
                if(player.convert(CGPoint(x: 0.0, y: -player.size.height / 2.0), to: self).y > platform.Top() - 10.0) {
                    platform.ActivateCollisions()
                } else {
                    platform.DeactivateCollisions()
                }
            }
        } else if(player.State == .Jumping) {
            for platform in Platforms {
                platform.DeactivateCollisions()
            }
        }
    }
    
    public func SpawnPlatform(scene: Game, number: Int, numberOfCoins: Int? = nil, yDistance: CGFloat = -1.0)
    {
        self.levelPlatformIndex = self.levelPlatformIndex + 1
        
        let platform = self.GetPlatform(platformNumber: number, yDistance: yDistance)
        self.addChild(platform)
        self.Platforms.append(platform)
        
        let n = numberOfCoins ?? (platform.PlatformNumber % 4 == 0 ? 5 : 0)
        platform.SpawnCoinsInWorld(world: scene.world, n: n)
        
        platform.DeactivateCollisions()
        
        self.SpawnWallTilesForPlatform(platform: platform)
        
        if(self.IsFinished()) {
            let c1 = SKAction.colorize(with: self.BackgroundColor(), colorBlendFactor: 1.0, duration: 0.4)
            let c2 = SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: 0.4)
            
            platform.run(SKAction.repeatForever(SKAction.sequence([c1, c2])))
        }
        
        /*
        if(self.Platforms.count > World.MAX_PLATFORMS)
        {
            let platform = Platforms.first
            self.Platforms.removeFirst()
            platform?.removeFromParent()
        }*/
    }
    
    public func TopPlatformY() -> CGFloat
    {
        return Platforms.last?.position.y ?? 0.0
    }
    
    func PlatformMinFactor() -> CGFloat
    {
        return 0.01
    }
    
    func PlatformMaxFactor() -> CGFloat
    {
        return 1.0
    }
    
    func IsFinished() -> Bool {
        return self.levelPlatformIndex == self.NumberOfPlatforms()
    }
    
    func PlatformYDistance() -> CGFloat {
        return 110.0
    }
    
    func NumberOfPlatforms() -> Int  {
        return 50
    }
    
    func LevelSpeed() -> CGFloat {
        return 1.0
    }
    
    func GameSpeed() -> CGFloat {
        return min(easeInSpeed, self.LevelSpeed())
    }
    
    func PlatformTexture() -> SKTexture? {
        return self.platformTexture;
    }
    
    func EaseInSpeed() {
        self.easeInSpeed = 0.0
        
        let easeInDuration = 5.0 // seconds
        let easeInStepTime = 0.25 // seconds
        let n = Int(easeInDuration / easeInStepTime)
        let easeInStep = self.LevelSpeed() / CGFloat(n)

        self.run(SKAction.repeat(SKAction.sequence([
            SKAction.wait(forDuration: easeInStepTime),
            SKAction.run {
                self.easeInSpeed += easeInStep
            }
        ]), count: n))
    }
}
