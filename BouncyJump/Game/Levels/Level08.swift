//
//  Level08.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level08: Level {
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.texturePlatform = SKTexture(imageNamed: "platformFinal")
        self.wallTexture = SKTexture(imageNamed: "wallFinal")
        self.textureBackground = SKTexture(imageNamed: "bgFinal")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var multiplicator: Int {
        return 8
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
