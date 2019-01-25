//
//  World.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation

import SpriteKit

class World : SKNode
{
    public var CurrentLevel : Level = Level01(worldWidth: 0)

    private var levels : [Level] = []
    private var currentPlatformNumber = 0
    
    private static let MAX_PLATFORMS = 50
    private static let MAX_WALL_TILES = 150
    static let WALL_WIDTH : CGFloat = 35.0
    
    // walls are invisible nodes, used only for collision with player, textures are spawned as tiles with platforms
    private let leftWall = SKSpriteNode.init(color: SKColor.init(white: 0.0, alpha: 0.0), size: CGSize(width: World.WALL_WIDTH, height: 0.0))
    private let rightWall = SKSpriteNode.init(color: SKColor.init(white: 0.0, alpha: 0.0), size: CGSize(width: World.WALL_WIDTH, height: 0.0))
    
    private var Platforms: [Platform] = []
    private var wallY: CGFloat = 0.0
    private var wallTiles: [SKSpriteNode] = []
    
    public var Height : CGFloat = 0.0
    public var Width : CGFloat = 0.0
    
    public func Create(_ scene : Game)
    {
        self.Platforms = []
        self.currentPlatformNumber = 0
        self.removeAllChildren()
        
        self.Width = scene.size.width * scene.xScale
        self.Height = scene.size.height * scene.yScale
        //print("Width: \(Width), Height: \(Height)")
        //print("Saclex: \(xScale), Scaley: \(yScale)")

        // left wall
        leftWall.size.height = Height * 3.0
        leftWall.position.x = -Width / 2.0 + World.WALL_WIDTH / 2.0
        leftWall.physicsBody = SKPhysicsBody.init(rectangleOf: leftWall.size)
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = NodeCategories.Wall
        leftWall.physicsBody?.contactTestBitMask = NodeCategories.Player | NodeCategories.Wall
        leftWall.physicsBody?.collisionBitMask = 0x0
        leftWall.name = "Wall" // TODO make own entity
        self.addChild(leftWall)
        leftWall.zPosition = NodeZOrder.World
        
        // right wall
        rightWall.size.height = Height * 3.0
        rightWall.position.x = Width / 2.0 - World.WALL_WIDTH / 2.0
        rightWall.physicsBody = SKPhysicsBody.init(rectangleOf: rightWall.size)
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = NodeCategories.Wall
        rightWall.physicsBody?.contactTestBitMask = NodeCategories.Player | NodeCategories.Wall
        rightWall.physicsBody?.collisionBitMask = 0x0
        rightWall.name = "Wall"
        self.addChild(rightWall)
        rightWall.zPosition = NodeZOrder.World
        self.wallY = AbsoluteZero()
        
        // levels
        self.levels = [
            Level01(worldWidth: Width),
            Level02(worldWidth: Width),
            Level03(worldWidth: Width),
            Level04(worldWidth: Width),
            Level05(worldWidth: Width),
            Level06(worldWidth: Width),
            Level07(worldWidth: Width),
            Level08(worldWidth: Width)];
        
        self.SpawnNextLevel(y: AbsoluteZero())
        scene.LevelReached(level: self.CurrentLevel)
        
        // floor
        let floorTexture = SKTexture(imageNamed: "platform01")
        let platform = Platform(width: Width, texture: floorTexture, level: self.CurrentLevel, platformNumber: 0)
        platform.position = CGPoint(x: 0.0, y: AbsoluteZero())
        self.addChild(platform)

        // first platforms
        for _ in 0..<8 {
            self.SpawnPlatform(scene: scene)
        }
    }
    
    public func SpawnNextLevel(y: CGFloat) {
        if(self.levels.count > 0) {
            self.CurrentLevel = self.levels.first!
            if(self.CurrentLevel is Level01) {
                self.CurrentLevel.CurrentY = y
            } else {
                self.CurrentLevel.CurrentY = y + 120.0
            }
            self.levels.remove(at: 0)
        }
    }
    
    public func UpdateCollisionTests(player : Player)
    {
        if(player.State == .Falling)
        {
            for platform in Platforms
            {
                if(player.Bottom() > platform.Top() - 10.0) {
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
    
    public func LandOnPlatform(platform: Platform, player: Player) {
        let y = platform.position.y
        self.SpawnPlatformsAbove(y: y)
        platform.HitPlayer(player: player)
        
        (self.scene as? Game)?.LevelReached(level: platform.Level)
    }
    
    public func SpawnPlatform(scene: Game)
    {
        self.currentPlatformNumber = self.currentPlatformNumber + 1
        
        let platform = self.CurrentLevel.GetPlatform(platformNumber: self.currentPlatformNumber)
        self.addChild(platform)
        self.Platforms.append(platform)
        
        self.SpawnWallTilesForPlatform(platform: platform)
        
        if(CurrentLevel.IsFinished()) {
            let c1 = SKAction.colorize(with: SKColor.red, colorBlendFactor: 0.5, duration: 0.4)
            let c2 = SKAction.colorize(with: SKColor.init(white: 0.0, alpha: 0.0), colorBlendFactor: 0.5, duration: 0.4)
            
            platform.run(SKAction.repeatForever(SKAction.sequence([c1, c2])))
            
            SpawnNextLevel(y: platform.position.y)
        }
        
        if(self.Platforms.count > World.MAX_PLATFORMS)
        {
            let platform = Platforms.first
            self.Platforms.removeFirst()
            platform?.removeFromParent()
        }
    }
    
    public func SpawnWallTilesForPlatform(platform: Platform)
    {
        let texL = platform.Level.wallLeftTexture
        let texR = platform.Level.wallRightTexture
        
        while(self.wallY <= platform.position.y) {
            let left = SKSpriteNode(texture: texL, color: SKColor.white, size: CGSize(width: World.WALL_WIDTH, height: World.WALL_WIDTH))
            let right = SKSpriteNode(texture: texR, color: SKColor.white, size: CGSize(width: World.WALL_WIDTH, height: World.WALL_WIDTH))
            
            self.addChild(left)
            self.addChild(right)
            
            self.wallTiles.append(left)
            self.wallTiles.append(right)
            
            left.position = CGPoint(x: -Width / 2.0 + World.WALL_WIDTH / 2.0, y: self.wallY)
            right.position = CGPoint(x: Width / 2.0 - World.WALL_WIDTH / 2.0, y: self.wallY)
            
            self.wallY += World.WALL_WIDTH
        }
        
        while(self.wallTiles.count > World.MAX_WALL_TILES) {
            self.wallTiles.first?.removeFromParent()
            self.wallTiles.removeFirst()
        }
    }
    
    public func SpawnPlatformsAbove(y : CGFloat)
    {
        while(TopPlatformY() - y < 6.0 * Height) {
            SpawnPlatform(scene: self.scene as! Game)
        }
    }
    
    public func UpdateWallY(_ y : CGFloat)
    {
        self.leftWall.position.y = y
        self.rightWall.position.y = y
    }
    
    public func TopPlatformY() -> CGFloat
    {
        return Platforms.last?.position.y ?? 0.0
    }
    
    public func AbsoluteZero() -> CGFloat
    {
        return -Height / 2.0 + Platform.HEIGHT / 2.0
    }
}
