//
//  Level02.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class LevelBase2: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformBase")
        self.texturePlatformEnds = SKTexture(imageNamed: "platformBaseEnds")
        self.textureWall = SKTexture(imageNamed: "wallBase")
        self.textureBackground = SKTexture(imageNamed: "bg")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var multiplicator: Int {
        return 2
    }

    override var backgroundColor: SKColor {
        return Colors.bgLevel02
    }
    
    override var platformMinFactor: CGFloat {
        return 0.3
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.75
    }
    
    override var levelSpeed: CGFloat {
        return 70.0
    }
    
    override var platformYDistance: CGFloat {
        return 0.3
    }

    override var amientParticleName: String? {
        return "AmbientOrange"
    }
}
