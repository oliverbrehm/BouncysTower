//
//  Level04.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 28.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level04: Level {
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
        return 4
    }
    
    override var backgroundColor: SKColor {
        return SKColor.init(named: "bgLevel04") ?? super.backgroundColor
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
        return 100.0
    }
    
    override var numberOfPlatforms: Int {
        return 80
    }
}
