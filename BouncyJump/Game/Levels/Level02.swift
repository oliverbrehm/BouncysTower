//
//  Level02.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Level02: Level {
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.texturePlatform = SKTexture(imageNamed: "platformBase")
        self.wallTexture = SKTexture(imageNamed: "wallBase")
        self.textureBackground = SKTexture(imageNamed: "bg")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var multiplicator: Int {
        return 2
    }

    override var backgroundColor: SKColor {
        return SKColor.init(named: "bgLevel02") ?? super.backgroundColor
    }
    
    override var platformMinFactor: CGFloat {
        return 0.25
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.8
    }
    
    override var levelSpeed: CGFloat {
        return 60.0
    }
    
    override var platformYDistance: CGFloat {
        return 85.0
    }
    
    override var numberOfPlatforms: Int {
        return 80
    }
}
