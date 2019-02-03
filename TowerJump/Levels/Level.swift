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
    var CurrentY : CGFloat
    var WorldWidth : CGFloat
    
    private var currentPlatformNumber = 0
    private var easeInSpeed: CGFloat = 999999999.0
    private var lastPlatform : Platform?
    
    var platformTexture : SKTexture?
    var wallLeftTexture: SKTexture?
    var wallRightTexture: SKTexture?
    
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
        WorldWidth = worldWidth
        CurrentY = 0.0
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func BackgroundColor() -> SKColor {
        return SKColor.black
    }
    
    func Reset() {
        self.currentPlatformNumber = 0
        self.CurrentY = 0.0
    }
    
    func GetPlatform(platformNumber: Int, yDistance: CGFloat = -1.0) -> Platform {
        if(yDistance < 0) {
            CurrentY += self.PlatformYDistance()
        } else {
            CurrentY += yDistance
        }
        
        self.currentPlatformNumber = self.currentPlatformNumber + 1
        
        let levelWidth = WorldWidth - 2 * World.WALL_WIDTH
        
        // TODO replace with Double.random in Swift 4.2
        var w : CGFloat
        var x : CGFloat
        
        if(self.currentPlatformNumber == 1 && !(self is Level01)) {
            w = WorldWidth
            x = 0.0
        } else {
            let minWidth = levelWidth * self.PlatformMinFactor()
            let maxWidth = levelWidth * self.PlatformMaxFactor()
            
            w = Level.RandomNumber(between: minWidth, and: maxWidth)
            x = Level.RandomNumber(
                between: -levelWidth / 2.0 + w / 2.0,
                and: levelWidth / 2.0 - w / 2.0)
        }
        
        var platform : Platform? = nil
        
        if(self.IsFinished()) {
            platform = PlatformEndLevel(width: w, texture: self.PlatformTexture(), level: self, platformNumber: platformNumber)
        } else {
            platform = Platform(width: w, texture: self.PlatformTexture(), level: self, platformNumber: platformNumber)
        }

        platform!.position = CGPoint(x: x, y: CurrentY)
        
        return platform!
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
        return self.currentPlatformNumber == self.NumberOfPlatforms()
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
