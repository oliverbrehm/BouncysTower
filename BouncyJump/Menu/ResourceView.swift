//
//  ResourceView.swift
//  BouncyJump iOS
//
//  Created by Oliver Brehm on 06.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ResourceView: Button, ShopDelegate {
    private let iconSize: CGFloat = 30.0
    private let textMargin: CGFloat = 5.0
    
    private lazy var lifeView = self.getLifeView()
    private lazy var coinView = self.getCoinView()

    private let lifeLabel = SKLabelNode(fontNamed: Constants.fontName)
    private let coinLabel = SKLabelNode(fontNamed: Constants.fontName)
    
    var shopDelegate: ShopDelegate?
    
    init() {
        super.init(size: CGSize(width: 50.0, height: 50.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func purchaseDone() {
        self.updateValues()
        self.shopDelegate?.purchaseDone()
    }
    
    func setup(position: CGPoint, shopDelegate: ShopDelegate? = nil) {
        self.shopDelegate = shopDelegate
        
        self.position = position
        self.zPosition = NodeZOrder.label
        
        self.addChild(lifeView)
        self.addChild(coinView)
        
        self.addChild(lifeLabel)
        self.addChild(coinLabel)
        
        self.action = {
            if let vc = self.scene?.view?.window?.rootViewController as? GameViewController {
                vc.showShop(delegate: self)
            }
        }
        
        self.updateValues()
    }
    
    private func getLifeView() -> SKSpriteNode {
        let lifeSprite = SKSpriteNode(imageNamed: "extralife")
        lifeSprite.size = CGSize(width: iconSize, height: iconSize)
        lifeSprite.zPosition = NodeZOrder.button
        
        lifeLabel.fontSize = 20.0
        lifeLabel.fontColor = SKColor.white
        
        return lifeSprite
    }
    
    private func getCoinView() -> SKSpriteNode {
        let coinSprite = SKSpriteNode(imageNamed: "coin")
        coinSprite.size = CGSize(width: iconSize, height: iconSize)
        coinSprite.zPosition = NodeZOrder.button
        
        coinLabel.fontSize = 20.0
        coinLabel.fontColor = SKColor.white
        
        return coinSprite
    }
    
    func updateValues() {
        self.lifeLabel.text = "x \(Config.standard.extraLives)"
        self.coinLabel.text = "x \(Config.standard.coins)"

        let width = iconSize + textMargin + max(lifeLabel.frame.size.width, coinLabel.frame.size.width)
        let height = 2 * iconSize + textMargin
        self.size = CGSize(width: width, height: height)
        
        lifeView.position = CGPoint(x: -width / 2.0 + iconSize / 2.0, y: textMargin / 2.0 + iconSize / 2.0)
        coinView.position = CGPoint(x: -width / 2.0 + iconSize / 2.0, y: -textMargin / 2.0 + -iconSize / 2.0)
        
        lifeLabel.position = CGPoint(x: -width / 2.0 + iconSize + textMargin + lifeLabel.frame.size.width / 2.0,
                                     y: textMargin / 2.0 + iconSize / 2.0 - lifeLabel.frame.size.height / 2.0)
        coinLabel.position = CGPoint(x: -width / 2.0 + iconSize + textMargin + coinLabel.frame.size.width / 2.0,
                                     y: -height / 2.0 + iconSize / 2.0 - coinLabel.frame.size.height / 2.0)
    }
}
