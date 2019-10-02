//
//  SuperJump.swift
//  BouncyJump iOS
//
//  Created by Oliver Brehm on 02.10.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class SuperJump: Collectable {
    
    private let radius: CGFloat = 30

    init() {
        super.init(textureName: "player", size: CGSize(width: radius, height: radius), useBacklight: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hit() {
        super.hit()
        
        run(SKAction.group([
            SKAction.fadeOut(withDuration: 0.2),
            SoundAction.collectSuperCoin.action
        ])) { [weak self] in
            self?.removeFromParent()
        }
    }
}
