//
//  Level07.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class LevelMoonStars: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformMoon")
        self.texturePlatformEnds = SKTexture(imageNamed: "platformEndsMoon")
        self.textureWall = SKTexture(imageNamed: "wallMoonStars")
        self.textureStaticBackground = SKTexture(imageNamed: "bgStaticMoonStars")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var multiplicator: Int {
        return 8
    }
    
    override var tintColor: SKColor {
        return Colors.bgMoon
    }
    
    override var platformMinFactor: CGFloat {
        return 0.15
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.3
    }
    
    override var levelSpeed: CGFloat {
        return 160.0
    }
    
    override var platformYDistance: CGFloat {
        return 0.4
    }
    
    override var amientParticleName: String? {
        return "AmbientMoon"
    }
}
