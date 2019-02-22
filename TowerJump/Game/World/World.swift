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
    var currentLevel: Level?
    let coinManager = CoinManager()

    var levels: [Level] = []
    private var currentPlatformNumber = 0
    
    static let wallWidth: CGFloat = 35.0
    
    // walls are invisible nodes, used only for collision with player, textures are spawned as tiles with platforms
    private let leftWall = SKSpriteNode.init(color: SKColor.init(white: 0.0, alpha: 0.0), size: CGSize(width: World.wallWidth, height: 0.0))
    private let rightWall = SKSpriteNode.init(color: SKColor.init(white: 0.0, alpha: 0.0), size: CGSize(width: World.wallWidth, height: 0.0))
    
    var height: CGFloat = 0.0
    var width: CGFloat = 0.0
    
    func create(_ scene : Game) {
        self.currentPlatformNumber = 0
        self.removeAllChildren()
        
        self.width = scene.size.width * scene.xScale
        self.height = scene.size.height * scene.yScale
        
        self.coinManager.setup(world: self)

        // left wall
        leftWall.size.height = height * 3.0
        leftWall.position.x = -width / 2.0 + World.wallWidth / 2.0
        leftWall.physicsBody = SKPhysicsBody.init(rectangleOf: leftWall.size)
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = NodeCategories.wall
        leftWall.physicsBody?.contactTestBitMask = NodeCategories.player | NodeCategories.wall
        leftWall.physicsBody?.collisionBitMask = 0x0
        leftWall.name = "Wall" // TODO make own entity
        self.addChild(leftWall)
        leftWall.zPosition = NodeZOrder.world
        
        // right wall
        rightWall.size.height = height * 3.0
        rightWall.position.x = width / 2.0 - World.wallWidth / 2.0
        rightWall.physicsBody = SKPhysicsBody.init(rectangleOf: rightWall.size)
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = NodeCategories.wall
        rightWall.physicsBody?.contactTestBitMask = NodeCategories.player | NodeCategories.wall
        rightWall.physicsBody?.collisionBitMask = 0x0
        rightWall.name = "Wall"
        self.addChild(rightWall)
        rightWall.zPosition = NodeZOrder.world
        
        // levels
        self.levels = [
            Level01(worldWidth: width),
            Level02(worldWidth: width),
            Level03(worldWidth: width),
            Level04(worldWidth: width),
            Level05(worldWidth: width),
            Level06(worldWidth: width),
            Level07(worldWidth: width),
            Level08(worldWidth: width)]
        
        self.currentLevel = nil
        self.spawnNextLevel()
        scene.levelReached(level: self.currentLevel!)
        
        self.spawnFloor()
    }
    
    func spawnFloor() {
        let floorTexture = SKTexture(imageNamed: "platform01")
        let platform = Platform(width: width - 2 * World.wallWidth, texture: floorTexture, level: self.currentLevel!, platformNumber: 0)
        platform.position = CGPoint(x: 0.0, y: absoluteZero())
        self.addChild(platform)
    }
    
    func spawnNextLevel() {
        let y = topPlatformY()
        if(self.levels.count > 0) {
            self.currentLevel?.fadeOutAndRemove()
            
            self.currentLevel = self.levels.removeFirst()
            self.addChild(self.currentLevel!)
            self.currentLevel!.fadeIn()
            self.currentLevel!.position = CGPoint(x: 0.0, y: y)
        }
    }
    
    func spawnPlatformsAbove(y : CGFloat) {
        while((self.currentLevel != nil && !self.currentLevel!.isFinished())
                && (topPlatformY() - y < 3.0 * height)) {
            self.spawnPlatform()
        }
    }
    
    func spawnPlatform(numberOfCoins: Int? = nil, yDistance: CGFloat = -1.0) {
        self.currentLevel!.spawnPlatform(scene: self.scene as! Game, number: self.currentPlatformNumber, numberOfCoins: numberOfCoins, yDistance: yDistance)
        self.currentPlatformNumber += 1
    }
    
    func topPlatformY() -> CGFloat {
        if let l = self.currentLevel {
            return l.topPlatformY() + l.position.y
        }
        
        return self.absoluteZero()
    }
    
    func landOnPlatform(platform: Platform, player: Player) {
        if(!platform.level.reached) {
            (self.scene as? Game)?.levelReached(level: platform.level)
        }
        platform.hitPlayer(player: player, world: self)
    }

    func updateWallY(_ y : CGFloat) {
        self.leftWall.position.y = y
        self.rightWall.position.y = y
    }

    func absoluteZero() -> CGFloat {
        return -height / 2.0 + Platform.height / 2.0
    }
}
