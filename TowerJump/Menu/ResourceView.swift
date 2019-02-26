//
//  ResourceView.swift
//  TowerJump iOS
//
//  Created by Oliver Brehm on 06.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ResourceView: Button {
    private let iconSize: CGFloat = 30.0
    private let textMargin: CGFloat = 5.0
    
    let lifeLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let coinLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    
    init() {
        super.init(
            caption: "", size: CGSize(width: 50.0, height: 50.0),
            fontSize: 0.0, fontColor: SKColor.clear, backgroundColor: SKColor.clear, pressedColor: SKColor.clear)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(position: CGPoint) {
        self.position = position
        self.zPosition = NodeZOrder.label
        
        let lifeView = self.getLifeView(y: 20.0)
        self.addChild(lifeView)
        
        let coinView = self.getCoinView(y: -20.0)
        self.addChild(coinView)
        
        self.action = {
            if let vc = self.scene?.view?.window?.rootViewController as? GameViewController {
                vc.showShop()
            }
        }
        
        self.updateValues()
    }
    
    private func getLifeView(y: CGFloat) -> SKSpriteNode {
        let lifeSprite = SKSpriteNode(imageNamed: "extralife")
        lifeSprite.position = CGPoint(x: -iconSize / 2.0, y: y)
        lifeSprite.size = CGSize(width: iconSize, height: iconSize)
        lifeSprite.zPosition = NodeZOrder.button
        
        lifeLabel.fontSize = 20.0
        lifeLabel.fontColor = SKColor.darkGray
        
        lifeSprite.addChild(lifeLabel)
        return lifeSprite
    }
    
    private func getCoinView(y: CGFloat) -> SKSpriteNode {
        let coinSprite = SKSpriteNode(imageNamed: "coin")
        coinSprite.position = CGPoint(x: -iconSize / 2.0, y: y)
        coinSprite.size = CGSize(width: iconSize, height: iconSize)
        coinSprite.zPosition = NodeZOrder.button
        
        coinLabel.fontSize = 20.0
        coinLabel.fontColor = SKColor.darkGray
        
        coinSprite.addChild(coinLabel)
        return coinSprite
    }
    
    func updateValues() {
        self.lifeLabel.text = "x \(Config.standard.extraLives)"
        lifeLabel.position = CGPoint(x: iconSize / 2.0 + lifeLabel.frame.size.width / 2.0 + textMargin, y: -lifeLabel.frame.size.height / 2.0)

        self.coinLabel.text = "x \(Config.standard.coins)"
        coinLabel.position = CGPoint(x: iconSize / 2.0 + coinLabel.frame.size.width / 2.0 + textMargin, y: -coinLabel.frame.size.height / 2.0)
        
        self.size = CGSize(width: coinLabel.frame.size.width + iconSize, height: 2 * coinLabel.frame.size.height + 20.0)
    }
}
