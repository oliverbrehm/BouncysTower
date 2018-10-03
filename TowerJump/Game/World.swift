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
    
    private static let MAX_PLATFORMS = 60
    static let WALL_WIDTH : CGFloat = 50.0
    
    private let leftWall = SKSpriteNode.init(color: SKColor.lightGray, size: CGSize(width: World.WALL_WIDTH, height: 0.0))
    private let rightWall = SKSpriteNode.init(color: SKColor.lightGray, size: CGSize(width: World.WALL_WIDTH, height: 0.0))
    private var Platforms : [Platform] = []
    
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
        
        // levels
        self.levels = []
        self.levels.append(Level01(worldWidth: Width))
        self.levels.append(Level02(worldWidth: Width))
        self.levels.append(Level03(worldWidth: Width))
        self.levels.append(Level04(worldWidth: Width))
        self.levels.append(Level05(worldWidth: Width))
        self.levels.append(Level06(worldWidth: Width))
        self.levels.append(Level07(worldWidth: Width))
        self.levels.append(Level08(worldWidth: Width))
        
        self.NextLevel(y: AbsoluteZero())
        
        // floor
        let platform = Platform(width: Width, color: SKColor.lightGray, level: self.CurrentLevel, platformNumber: 0)
        platform.position = CGPoint(x: 0.0, y: AbsoluteZero())
        self.addChild(platform)

        // first platforms
        for _ in 0..<8 {
            self.SpawnPlatform(scene: scene)
        }
    }
    
    public func NextLevel(y: CGFloat) {
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
            for var platform in Platforms
            {
                if(player.Bottom() > platform.Top() - 10.0) {
                    platform.ActivateCollisions()
                } else {
                    platform.DeactivateCollisions()
                }
            }
        } else if(player.State == .Jumping) {
            for var platform in Platforms {
                platform.DeactivateCollisions()
            }
        }
    }
    
    public func LandOnPlatform(platform: Platform, player: Player) {
        let y = platform.position.y
        self.SpawnPlatformsAbove(y: y)
        platform.HitPlayer(player: player)
    }
    
    public func SpawnPlatform(scene: Game) -> Bool
    {
        self.currentPlatformNumber = self.currentPlatformNumber + 1
        
        let platform = self.CurrentLevel.GetPlatform(platformNumber: self.currentPlatformNumber)
        self.addChild(platform)
        self.Platforms.append(platform)
        
        if(CurrentLevel.IsFinished()) {
            let c1 = SKAction.colorize(with: SKColor.red, colorBlendFactor: 0.5, duration: 0.4)
            let c2 = SKAction.colorize(with: CurrentLevel.Color(), colorBlendFactor: 0.5, duration: 0.4)
            
            platform.run(SKAction.repeatForever(SKAction.sequence([c1, c2])))
            
            NextLevel(y: platform.position.y)
        }
        
        if(self.Platforms.count > World.MAX_PLATFORMS)
        {
            let platform = Platforms.first
            self.Platforms.removeFirst()
            platform?.removeFromParent()
        }
        
        return true
        // TODO return false REMOVE? fuer platform kann nicht erstellt werden
    }
    
    public func SpawnPlatformsAbove(y : CGFloat)
    {
        while(TopPlatformY() - y < 10.0 * Height) {
            if(!SpawnPlatform(scene: self.scene as! Game)) {
                break
            }
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
