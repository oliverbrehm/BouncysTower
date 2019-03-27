//
//  Level03.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 28.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class LevelSnow: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformSnow")
        self.texturePlatformEnds = SKTexture(imageNamed: "platformEndsSnow")
        self.textureWall = SKTexture(imageNamed: "wallSnow")
        self.textureBackground = SKTexture(imageNamed: "bgSnow")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var amientParticleName: String? {
        return "AmbientSnow"
    }
    
    override var multiplicator: Int {
        return 3
    }
    
    override var backgroundColor: SKColor {
        return SKColor.white
    }
    
    override var platformMinFactor: CGFloat {
        return 0.3
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.7
    }
    
    override var levelSpeed: CGFloat {
        return 70.0
    }
    
    override var platformYDistance: CGFloat {
        return 0.3
    }
    
    override var numberOfPlatforms: Int {
        return 70
    }
}
