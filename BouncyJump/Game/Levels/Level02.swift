//
//  Level02.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Level02: Level {
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
