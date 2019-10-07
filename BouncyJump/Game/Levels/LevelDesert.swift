//
//  Level04.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 28.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class LevelDesert: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformDesert")
        self.texturePlatformEnds = SKTexture(imageNamed: "platformEndsDesert")
        self.textureWall = SKTexture(imageNamed: "wallDesert")
        self.textureBackground = SKTexture(imageNamed: "bgDesert")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var multiplicator: Int {
        return 3
    }
    
    override var tintColor: SKColor {
        return SKColor.darkGray
    }
    
    override var platformMinFactor: CGFloat {
        return 0.3
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.65
    }
    
    override var levelSpeed: CGFloat {
        return 90.0
    }
    
    override var platformYDistance: CGFloat {
        return 0.3
    }
    
    override var amientParticleName: String? {
        return "AmbientDesert"
    }
}
