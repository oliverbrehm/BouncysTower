//
//  StandardPlatform.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 13.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class StandardPlatform: Platform {
    
    override init(
        width: CGFloat,
        texture: SKTexture?,
        textureEnds: SKTexture?,
        level: Level, platformNumber: Int, platformNumberInLevel: Int,
        backgroundColor: SKColor = SKColor.white, tileColor: SKColor? = nil) {
        super.init(width: width, texture: texture, textureEnds: textureEnds, level: level,
                   platformNumber: platformNumber, platformNumberInLevel: platformNumberInLevel,
                   backgroundColor: backgroundColor, tileColor: tileColor)
        
        // consumables, if one item was spawned return, so only one item can be on a platform
        guard !spawnBrick() else { return }
        guard !spawnExtraLife() else { return }
        guard !spawnSuperCoin() else { return }
        _ = spawnSuperJump()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
