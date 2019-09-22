//
//  Level01.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class LevelBase1: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformBase")
        self.texturePlatformEnds = SKTexture(imageNamed: "platformBaseEnds")
        self.textureWall = SKTexture(imageNamed: "wallBase")
        self.textureBackground = SKTexture(imageNamed: "bg")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        return 0.22
    }
    
    override var firstPlatformOffset: CGFloat {
        // no offset for first level
        return 0.0
    }
    
    override var numberOfPlatforms: Int {
        return 60
    }
}
