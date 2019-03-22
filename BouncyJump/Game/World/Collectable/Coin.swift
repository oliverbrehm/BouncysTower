//
//  Coin.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Coin: Collectable {
    static let size: CGFloat = 12.0
    
    private let manager: CoinManager
    
    init(manager: CoinManager) {
        self.manager = manager
        
        super.init(textureName: "coin", size: CGSize(width: Coin.size, height: Coin.size))
    }
    
    override func hit() {
        super.hit()
        
        Config.standard.addCoin()

        self.run(SKAction.sequence([
            SKAction.group([
                SoundController.standard.getSoundAction(action: .coin),
                SKAction.sequence([
                    SKAction.moveBy(x: 0.0, y: 4.0, duration: 0.1),
                    SKAction.scale(by: 0.2, duration: 0.1),
                    SKAction.fadeOut(withDuration: 0.2)
                ])
            ]),
            SKAction.run {
                self.removeAllActions()
                self.removeFromParent()
                self.manager.removeCoin(coin: self)
            }
        ]))
    }
    override var score: Int {
        return 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        manager = CoinManager()
        super.init(coder: aDecoder)
    }
}
