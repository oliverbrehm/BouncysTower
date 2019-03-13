//
//  Level08.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level08: Level {
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.texturePlatform = SKTexture(imageNamed: "platform02")
        self.wallLeftTexture = SKTexture(imageNamed: "wallLeft01")
        self.wallRightTexture = SKTexture(imageNamed: "wallRight01")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var backgroundColor: SKColor {
        return SKColor.init(named: "bgLevel08") ?? super.backgroundColor
    }
    
    override var platformMinFactor: CGFloat {
        return 0.10
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.24
    }
    
    override var levelSpeed: CGFloat {
        return 120.0
    }
    
    override var numberOfPlatforms: Int {
        return Int.max
    }
    
    override var platformYDistance: CGFloat {
        return 100.0
    }
}
