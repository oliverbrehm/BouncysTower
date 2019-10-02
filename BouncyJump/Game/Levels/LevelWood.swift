//
//  LevelWood.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 27.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class LevelWood: Level {
    override init(world: World) {
        super.init(world: world)
        self.texturePlatform = SKTexture(imageNamed: "platformWood")
        self.texturePlatformEnds = SKTexture(imageNamed: "platformEndsWood")
        self.textureWall = SKTexture(imageNamed: "wallWood")
        self.textureBackground = SKTexture(imageNamed: "bgWood")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var multiplicator: Int {
        return 4
    }
    
    override var backgroundColor: SKColor {
        return SKColor.white
    }
    
    override var platformMinFactor: CGFloat {
        return 0.25
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.6
    }
    
    override var levelSpeed: CGFloat {
        return 110.0
    }
    
    override var platformYDistance: CGFloat {
        return 0.3
    }
    
    override var amientParticleName: String? {
        return "AmbientRain"
    }
}
