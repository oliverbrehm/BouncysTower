//
//  Level.swift
//  TowerJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Level
{
    var CurrentY : CGFloat
    var WorldWidth : CGFloat
    
    private var currentPlatformNumber = 0
    
    private var lastPlatform : Platform?
    
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
    }
    
    func Color() -> SKColor {
        return SKColor.white
    }
    
    func GetPlatform(platformNumber: Int) -> Platform {
        CurrentY += self.PlatformYDistance()
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
            platform = PlatformEndLevel(width: w, color: self.Color(), level: self, platformNumber: platformNumber)
        } else {
            platform = Platform(width: w, color: self.Color(), level: self, platformNumber: platformNumber)
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
    
    func GameSpeed() -> CGFloat {
        return 1.0
    }
}
