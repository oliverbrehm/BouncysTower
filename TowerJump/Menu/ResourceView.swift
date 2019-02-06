//
//  ResourceView.swift
//  TowerJump iOS
//
//  Created by Oliver Brehm on 06.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ResourceView : SKNode
{
    private let ICON_SIZE: CGFloat = 30.0
    private let TEXT_MARGIN: CGFloat = 5.0
    
    let lifeLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let coinLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")

    func Setup(position: CGPoint) {
        self.position = position
        self.zPosition = NodeZOrder.Label
        
        let lifeView = self.GetLifeView(y: 20.0)
        self.addChild(lifeView)
        
        let coinView = self.GetCoinView(y: -20.0)
        self.addChild(coinView)
        
        self.UpdateValues()
    }
    
    private func GetLifeView(y: CGFloat) -> SKSpriteNode {
        let lifeSprite = SKSpriteNode(imageNamed: "extralife")
        lifeSprite.position = CGPoint(x: -ICON_SIZE / 2.0, y: y)
        lifeSprite.size = CGSize(width: ICON_SIZE, height: ICON_SIZE)
        lifeSprite.zPosition = NodeZOrder.Button
        
        lifeLabel.fontSize = 20.0
        lifeLabel.fontColor = SKColor.darkGray
        
        lifeSprite.addChild(lifeLabel)
        return lifeSprite
    }
    
    private func GetCoinView(y: CGFloat) -> SKSpriteNode {
        let coinSprite = SKSpriteNode(imageNamed: "coin")
        coinSprite.position = CGPoint(x:  -ICON_SIZE / 2.0, y: y)
        coinSprite.size = CGSize(width: ICON_SIZE, height: ICON_SIZE)
        coinSprite.zPosition = NodeZOrder.Button
        
        coinLabel.fontSize = 20.0
        coinLabel.fontColor = SKColor.darkGray
        
        coinSprite.addChild(coinLabel)
        return coinSprite
    }
    
    public func UpdateValues() {
        self.lifeLabel.text = "x \(Config.Default.ExtraLives)"
        lifeLabel.position = CGPoint(x: ICON_SIZE / 2.0 + lifeLabel.frame.size.width / 2.0 + TEXT_MARGIN, y: -lifeLabel.frame.size.height / 2.0)

        self.coinLabel.text = "x \(Config.Default.Coins)"
        coinLabel.position = CGPoint(x: ICON_SIZE / 2.0 + coinLabel.frame.size.width / 2.0 + TEXT_MARGIN, y: -coinLabel.frame.size.height / 2.0)
    }
}
