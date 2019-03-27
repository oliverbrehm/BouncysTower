//
//  Level04.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 28.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class LevelDesert: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformMoon")
        self.texturePlatformEnds = SKTexture(imageNamed: "platformEndsMoon")
        self.textureWall = SKTexture(imageNamed: "wallMoonStars")
        self.textureStaticBackground = SKTexture(imageNamed: "bgStaticMoonStars")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var multiplicator: Int {
        return 4
    }
    
    override var backgroundColor: SKColor {
        return SKColor.white
    }
    
    override var platformMinFactor: CGFloat {
        return 0.2
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.65
    }
    
    override var levelSpeed: CGFloat {
        return 80.0
    }
    
    override var platformYDistance: CGFloat {
        return 0.3
    }
    
    override var numberOfPlatforms: Int {
        return 80
    }
}
