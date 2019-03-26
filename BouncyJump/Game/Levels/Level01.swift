//
//  Level01.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Level01: Level {
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.texturePlatform = SKTexture(imageNamed: "platformBase")
        self.texturePlatformEnds = SKTexture(imageNamed: "platformBaseEnds")
        self.textureWall = SKTexture(imageNamed: "wallBase")
        self.textureBackground = SKTexture(imageNamed: "bg")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var multiplicator: Int {
        return 1
    }
    
    override var backgroundColor: SKColor {
        return SKColor.init(named: "bgLevel01") ?? super.backgroundColor
    }

    override var platformMinFactor: CGFloat {
        return 0.2
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.9
    }
    
    override var levelSpeed: CGFloat {
        return 40.0
    }
    
    override var platformYDistance: CGFloat {
        return 70.0
    }
    
    override var firstPlatformOffset: CGFloat {
        // no offset for first level
        return 0.0
    }
    
    override var numberOfPlatforms: Int {
        return 100
    }
}
