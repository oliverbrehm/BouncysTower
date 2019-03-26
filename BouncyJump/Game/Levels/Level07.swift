//
//  Level07.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level07: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformFinal")
        self.textureWall = SKTexture(imageNamed: "wallFinal")
        self.textureBackground = SKTexture(imageNamed: "bgFinal")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var staticBackground: Bool {
        return true
    }
    
    override var multiplicator: Int {
        return 7
    }
    
    override var backgroundColor: SKColor {
        return SKColor.init(named: "bgLevel07") ?? super.backgroundColor
    }
    
    override var platformMinFactor: CGFloat {
        return 0.15
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.35
    }
    
    override var levelSpeed: CGFloat {
        return 110.0
    }
    
    override var platformYDistance: CGFloat {
        return 0.4
    }
    
    override var numberOfPlatforms: Int {
        return 100
    }
}
