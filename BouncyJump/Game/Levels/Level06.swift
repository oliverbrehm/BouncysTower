//
//  Level06.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level06: Level {
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.texturePlatform = SKTexture(imageNamed: "platformFinal")
        self.textureWall = SKTexture(imageNamed: "wallFinal")
        self.textureBackground = SKTexture(imageNamed: "bgFinal")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var multiplicator: Int {
        return 6
    }

    override var backgroundColor: SKColor {
        return SKColor.init(named: "bgLevel06") ?? super.backgroundColor
    }
    
    override var platformMinFactor: CGFloat {
        return 0.2
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.40
    }
    
    override var levelSpeed: CGFloat {
        return 100.0
    }
    
    override var platformYDistance: CGFloat {
        return 100.0
    }
    
    override var numberOfPlatforms: Int {
        return 80
    }
}
