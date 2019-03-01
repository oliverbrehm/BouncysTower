//
//  Credits.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Settings: SKScene {
    var gameViewController: GameViewController?
    
    override func didMove(to view: SKView) {
        let towerImage = SKSpriteNode(imageNamed: "bg")
        towerImage.zPosition = NodeZOrder.background + 0.01
        towerImage.color = SKColor(named: "bgLevel01") ?? SKColor.white
        towerImage.colorBlendFactor = 1.0
        towerImage.size = self.size
        towerImage.position = CGPoint.zero
        self.addChild(towerImage)
        
        let leftX = -0.25 * self.size.width
        let rightX = 0.25 * self.size.width
        
        let scoreNode = ScoreNode()
        scoreNode.position = CGPoint(x: leftX, y: -15.0)
        self.addChild(scoreNode)
        
        let info1 = SKLabelNode(text: "Made by")
        info1.fontColor = SKColor.green
        info1.fontName = "AmericanTypewriter-Bold"
        info1.fontSize = 22.0
        info1.position = CGPoint(x: rightX, y: -70.0)
        info1.zPosition = NodeZOrder.label
        self.addChild(info1)
        
        let info2 = SKLabelNode(text: "Oliver Brehm")
        info2.fontColor = SKColor.green
        info2.fontName = "AmericanTypewriter-Bold"
        info2.fontSize = 22.0
        info2.position = CGPoint(x: rightX, y: -100.0)
        info2.zPosition = NodeZOrder.label
        self.addChild(info2)
        
        let shopButton = IconButton(image: "shop")
        shopButton.position = CGPoint(x: rightX, y: 80.0)
        shopButton.action = {
            self.gameViewController?.showShop()
        }
        self.addChild(shopButton)
        
        let backButton = IconButton(image: "back")
        backButton.position = CGPoint(x: rightX, y: 0.0)
        backButton.action = {
            self.gameViewController?.showMainMenu()
        }
        self.addChild(backButton)
    }
}
