//
//  StandardPlatform.swift
//  TowerJump
//
//  Created by Oliver Brehm on 13.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class StandardPlatform: Platform {
    
    override init(width: CGFloat, texture: SKTexture?, level: Level, platformNumber: Int, backgroundColor: SKColor = SKColor.white) {
        super.init(width: width, texture: texture, level: level,
                   platformNumber: platformNumber, backgroundColor: backgroundColor)
        
        // consumables
        self.spawnBrick()
        self.spawnExtraLife()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
