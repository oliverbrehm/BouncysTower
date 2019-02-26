//
//  ShopScene.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

// TODO REMOVE! new shop is done with UIKit

class ShopItem: SKSpriteNode {
    
    init(size: CGSize, title: String, descriptionText: String, texture: SKTexture) {
        super.init(texture: nil, color: SKColor.purple, size: size)
        
        let margin: CGFloat = 10.0
        let imageSize = size.height - margin
        
        let image = SKSpriteNode(texture: texture)
        image.size = CGSize(width: imageSize, height: imageSize)
        image.position = CGPoint(x: -size.width / 2.0 + margin + imageSize / 2.0, y: 0.0)
        self.addChild(image)
        
        let textX = -size.width / 2.0 + margin + imageSize + margin
        
        let titleLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        titleLabel.text = title
        titleLabel.fontColor = SKColor.black
        titleLabel.fontSize = 20.0
        self.addChild(titleLabel)
        titleLabel.position = CGPoint(
            x: textX + titleLabel.frame.size.width / 2.0,
            y: size.height / 2.0 - margin - titleLabel.frame.size.height)
        
        let descriptionLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        descriptionLabel.text = descriptionText
        descriptionLabel.fontColor = SKColor.black
        descriptionLabel.fontSize = 14.0
        self.addChild(descriptionLabel)
        descriptionLabel.position = CGPoint(
            x: textX + descriptionLabel.frame.size.width / 2.0,
            y: size.height / 2.0 - margin - titleLabel.frame.size.height - margin / 2.0 - descriptionLabel.frame.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(texture: nil, color: SKColor.purple, size: CGSize.zero)
    }
}

class ShopScene: SKScene {
    func setup(gameViewController: GameViewController) {
        let width = self.size.width * self.xScale
        // let height = self.size.height * self.yScale
        
        let titleLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        titleLabel.fontColor = SKColor.yellow
        titleLabel.fontSize = 30.0
        titleLabel.text = "SHOP"
        self.addChild(titleLabel)
        // TODO set size according to scene height
        titleLabel.position = CGPoint(x: 0.0, y: 150.0 - titleLabel.frame.size.height - 10.0)

        let lifeItem = ShopItem(
            size: CGSize(width: width * 0.5, height: 65.0),
            title: "Extralife",
            descriptionText: "Saves you once when falling down.",
            texture: SKTexture.init(imageNamed: "extralife"))
        lifeItem.position = CGPoint(x: 0.0, y: 40.0)
        self.addChild(lifeItem)
        
        let brickItem = ShopItem(
            size: CGSize(width: width * 0.5, height: 65.0),
            title: "Brick",
            descriptionText: "Use it to build your personal tower.",
            texture: SKTexture.init(imageNamed: "platform01"))
        brickItem.position = CGPoint(x: 0.0, y: -40.0)
        self.addChild(brickItem)
        
        let backButton = Button(caption: "Back")
        // TODO set size according to scene height
        backButton.position = CGPoint(x: 0.0, y: -190.0 + backButton.frame.size.height + 10.0)
        backButton.action = {
            gameViewController.showSettings()
        }
        self.addChild(backButton)
    }
}
