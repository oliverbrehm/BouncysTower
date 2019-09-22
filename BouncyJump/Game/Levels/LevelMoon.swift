//
//  Level06.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class LevelMoon: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformMoon")
        self.texturePlatformEnds = SKTexture(imageNamed: "platformEndsMoon")
        self.textureWall = SKTexture(imageNamed: "wallMoon")
        self.textureBackground = SKTexture(imageNamed: "bgMoon")
        self.textureStaticBackground = SKTexture(imageNamed: "bgStaticMoon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var multiplicator: Int {
        return 7
    }

    override var backgroundColor: SKColor {
        return SKColor.white
    }
    
    override var platformMinFactor: CGFloat {
        return 0.15
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.45
    }
    
    override var levelSpeed: CGFloat {
        return 130
    }
    
    override var platformYDistance: CGFloat {
        return 0.35
    }
    
    override var numberOfPlatforms: Int {
        return 100
    }
}
