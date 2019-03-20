//
//  Credits.swift
//  BouncyJump
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
        info1.fontColor = Constants.colors.menuForeground
        info1.fontName = Constants.fontName
        info1.fontSize = 25.0
        info1.position = CGPoint(x: rightX, y: -100.0)
        info1.zPosition = NodeZOrder.label
        self.addChild(info1)
        
        let info2 = SKLabelNode(text: "Oliver Brehm")
        info2.fontColor = SKColor.white
        info2.fontName = Constants.fontName
        info2.fontSize = 22.0
        info2.position = CGPoint(x: rightX, y: -130.0)
        info2.zPosition = NodeZOrder.label
        self.addChild(info2)
        
        let shopButton = IconDescriptionButton(description: "SHOP", image: "shop")
        shopButton.position = CGPoint(x: rightX, y: 80.0)
        shopButton.action = {
            self.gameViewController?.showShop()
        }
        self.addChild(shopButton)
        
        let backButton = IconDescriptionButton(description: "BACK", image: "back")
        backButton.position = CGPoint(x: rightX, y: 0.0)
        backButton.action = {
            self.gameViewController?.showMainMenu()
        }
        self.addChild(backButton)
    }
}
