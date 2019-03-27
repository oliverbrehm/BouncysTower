//
//  LevelSun.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 27.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class LevelSun: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformSnow")
        self.texturePlatformEnds = SKTexture(imageNamed: "platformEndsSnow")
        self.textureWall = SKTexture(imageNamed: "wallSnow")
        self.textureBackground = SKTexture(imageNamed: "bgSnow")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var amientParticleName: String? {
        return "AmbientSnow"
    }
    
    override var multiplicator: Int {
        return 2
    }
    
    override var backgroundColor: SKColor {
        return SKColor.init(named: "bgLevel02") ?? super.backgroundColor
    }
    
    override var platformMinFactor: CGFloat {
        return 0.25
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.8
    }
    
    override var levelSpeed: CGFloat {
        return 60.0
    }
    
    override var platformYDistance: CGFloat {
        return 0.3
    }
    
    override var numberOfPlatforms: Int {
        return 100
    }
}
