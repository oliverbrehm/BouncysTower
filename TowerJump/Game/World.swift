//
//  World.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class World : SKNode
{
    public var CurrentLevel : Level?

    private var levels : [Level] = []
    private var coins: [Coin] = []
    private var currentPlatformNumber = 0
    
    static let WALL_WIDTH : CGFloat = 35.0
    
    // walls are invisible nodes, used only for collision with player, textures are spawned as tiles with platforms
    private let leftWall = SKSpriteNode.init(color: SKColor.init(white: 0.0, alpha: 0.0), size: CGSize(width: World.WALL_WIDTH, height: 0.0))
    private let rightWall = SKSpriteNode.init(color: SKColor.init(white: 0.0, alpha: 0.0), size: CGSize(width: World.WALL_WIDTH, height: 0.0))
    
    public var Height : CGFloat = 0.0
    public var Width : CGFloat = 0.0
    
    public func Create(_ scene : Game)
    {
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
        scene.LevelReached(level: self.CurrentLevel!)
        
        self.SpawnFloor(numberOfCoins: 0)
    }
    
    public func SpawnFloor(numberOfCoins: Int) {
        let floorTexture = SKTexture(imageNamed: "platform01")
        let platform = Platform(width: Width - 2 * World.WALL_WIDTH, texture: floorTexture, level: self.CurrentLevel!, platformNumber: 0)
        platform.position = CGPoint(x: 0.0, y: AbsoluteZero())
        self.addChild(platform)
        platform.SpawnCoinsInWorld(world: self, n: numberOfCoins)
    }
    
    public func SpawnCoin(position: CGPoint) {
        let coin = Coin()
        coin.position = position
        self.addChild(coin)
        self.coins.append(coin)
    }
    
    public func NumberOfCoins() -> Int {
        return self.coins.count
    }
    
    public func RemoveCoin(coin: Coin) {
        if let index = self.coins.index(of: coin) {
            self.coins.remove(at: index)
        }
    }
    
    public func SpawnNextLevel(y: CGFloat) {
        if(self.levels.count > 0) {
            self.CurrentLevel = self.levels.first!
            self.addChild(self.CurrentLevel!)
            self.CurrentLevel!.position = CGPoint(x: 0.0, y: y)
            self.levels.remove(at: 0)
        }
    }
    
    public func SpawnPlatformsAbove(y : CGFloat)
    {
        while(TopPlatformY() - y < 3.0 * Height) {
            self.SpawnPlatform()
        }
    }
    
    public func SpawnPlatform(numberOfCoins: Int? = nil, yDistance: CGFloat = -1.0) {
        self.CurrentLevel!.SpawnPlatform(scene: self.scene as! Game, number: self.currentPlatformNumber, numberOfCoins: numberOfCoins, yDistance: yDistance)
        self.currentPlatformNumber = self.currentPlatformNumber + 1
        if(self.CurrentLevel!.IsFinished()) {
            self.SpawnNextLevel(y: TopPlatformY())
        }
    }
    
    public func TopPlatformY() -> CGFloat {
        return self.CurrentLevel!.TopPlatformY() + self.CurrentLevel!.position.y
    }
    
    public func UpdateCollisionTests(player : Player)
    {
        self.CurrentLevel!.UpdateCollisionTests(player: player)
        if(self.CurrentLevel != player.CurrentLevel) {
            player.CurrentLevel?.UpdateCollisionTests(player: player)
        }
    }
    
    public func LandOnPlatform(platform: Platform, player: Player) {
        if(!platform.Level.Reached) {
            (self.scene as? Game)?.LevelReached(level: platform.Level)
            player.CurrentLevel = platform.Level
        }
        platform.HitPlayer(player: player)
    }

    public func UpdateWallY(_ y : CGFloat)
    {
        self.leftWall.position.y = y
        self.rightWall.position.y = y
    }

    public func AbsoluteZero() -> CGFloat
    {
        return -Height / 2.0 + Platform.HEIGHT / 2.0
    }
}
