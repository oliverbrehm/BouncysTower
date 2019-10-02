//
//  Level08.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class LevelFinal: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformFinal")
        self.textureWall = SKTexture(imageNamed: "wallFinal")
        self.textureStaticBackground = SKTexture(imageNamed: "bgFinal")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var multiplicator: Int {
        return 10
    }

    override var backgroundColor: SKColor {
        return SKColor.white
    }
    
    override var platformMinFactor: CGFloat {
        return 0.10
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.25
    }
    
    override var levelSpeed: CGFloat {
        return 200.0
    }
    
    override var numberOfPlatforms: Int {
        return Int.max
    }
    
    override var platformYDistance: CGFloat {
        return 0.4
    }
    
    override var amientParticleName: String? {
        return "AmbientFinal"
    }
    
    override func getPlatform(platformNumber: Int, yDistance: CGFloat = -1.0) -> Platform? {
        let platform = super.getPlatform(platformNumber: platformNumber, yDistance: yDistance)
        
        // TODO colorize tiles
        
        return platform
    }
}
