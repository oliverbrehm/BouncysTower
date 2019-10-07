//
//  Level05.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class LevelSunset: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformSunset")
        self.textureWall = SKTexture(imageNamed: "wallSunset")
        self.textureStaticBackground = SKTexture(imageNamed: "bgSunsetStatic")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var multiplicator: Int {
        return 6
    }
    
    override var tintColor: SKColor {
        return Colors.bgSunset
    }
    
    override var platformMinFactor: CGFloat {
        return 0.2
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.5
    }
    
    override var levelSpeed: CGFloat {
        return 125.0
    }
    
    override var platformYDistance: CGFloat {
        return 0.35
    }

    override var amientParticleName: String? {
        return "AmbientSunset"
    }
}
