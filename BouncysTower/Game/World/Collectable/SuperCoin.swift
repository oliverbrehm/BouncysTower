//
//  SuperCoin.swift
//  BouncysTower iOS
//
//  Created by Oliver Brehm on 02.10.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class SuperCoin: Collectable {
    
    static let coinTexture = SKTexture(imageNamed: "coin")
    
    private let nCoins = 15
    private let sizeRadius: CGFloat = 30
    private let smallCoinRadius: CGFloat = 15
    private let explosionRadius: CGFloat = 350
    
    init() {
        super.init(textureName: "coin", size: CGSize(width: sizeRadius, height: sizeRadius), useBacklight: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var score: Int {
        return nCoins
    }
    
    override func hit() {
        super.hit()
        
        Config.standard.addCoins(nCoins)
        
        for index in 0 ..< nCoins {
            let explosionAngle = CGFloat(index) / CGFloat(nCoins) * CGFloat.pi * 2
            let coin = SKSpriteNode(texture: SuperCoin.coinTexture, size: CGSize(width: smallCoinRadius, height: smallCoinRadius))
            addChild(coin)
            
            coin.run(SKAction.group([
                SKAction.move(to: randomPosition(onRadius: explosionRadius, withAngle: explosionAngle), duration: 0.4),
                SKAction.resize(byWidth: smallCoinRadius, height: smallCoinRadius, duration: 0.4),
                SKAction.fadeOut(withDuration: 0.6)
            ])) {
                coin.removeFromParent()
            }
        }
        
        run(SKAction.group([
            SKAction.fadeOut(withDuration: 0.6),
            SoundAction.collectSuperCoin.action
        ])) { [weak self] in
            self?.removeFromParent()
        }
    }
    
    // MARK: - private functions
    private func randomPosition(onRadius radius: CGFloat, withAngle angle: CGFloat) -> CGPoint {
        return CGPoint(x: cos(angle) * radius, y: sin(angle) * radius)
    }
}
