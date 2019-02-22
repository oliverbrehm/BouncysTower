//
//  Level02.swift
//  TowerJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Level02: Level {
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.texturePlatform = SKTexture(imageNamed: "platform02")
        self.wallLeftTexture = SKTexture(imageNamed: "wallLeft01")
        self.wallRightTexture = SKTexture(imageNamed: "wallRight01")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func backgroundColor() -> SKColor {
        return SKColor.init(named: "bgLevel02") ?? super.backgroundColor()
    }
    
    override func platformMinFactor() -> CGFloat {
        return 0.4
    }
    
    override func platformMaxFactor() -> CGFloat {
        return 0.7
    }
    
    override func levelSpeed() -> CGFloat {
        return 60.0
    }
}
