//
//  Level03.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 28.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level03: Level {
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
        return 3
    }
    
    override var backgroundColor: SKColor {
        return SKColor.init(named: "bgLevel03") ?? super.backgroundColor
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
        return 100.0
    }
    
    override var numberOfPlatforms: Int {
        return 70
    }
}
