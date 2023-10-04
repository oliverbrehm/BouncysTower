//
//  Credits.swift
//  BouncysTower
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
        towerImage.color = Colors.bgLevel01
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
        info1.fontColor = Colors.menuForeground
        info1.fontName = Font.fontName
        info1.fontSize = 20.0
        info1.position = CGPoint(x: rightX, y: -120.0)
        info1.zPosition = NodeZOrder.label
        self.addChild(info1)
        
        let info2 = SKLabelNode(text: "Oliver Brehm")
        info2.fontColor = SKColor.white
        info2.fontName = Font.fontName
        info2.fontSize = 16.0
        info2.position = CGPoint(x: rightX, y: -145.0)
        info2.zPosition = NodeZOrder.label
        self.addChild(info2)
        
        let shopButton = IconDescriptionButton(description: Strings.MenuMain.shopTitle, image: "shop")
        shopButton.position = CGPoint(x: rightX, y: 120.0)
        shopButton.action = {
            self.gameViewController?.showShop()
        }
        self.addChild(shopButton)
        
        let gameCenterButton = IconDescriptionButton(description: "GAME CENTER", image: "options")
        gameCenterButton.position = CGPoint(x: rightX, y: 50)
        gameCenterButton.action = {
            /*#if DEBUG
            Config.standard.reset()
            TowerBricks.standard.reset()
            Score.standard.reset()
            InAppPurchaseManager.shared.premiumPurchased = false
            #else*/
            GameCenterManager.standard.showLeaderboard()
            // #endif
        }
        self.addChild(gameCenterButton)
        
        let backButton = IconDescriptionButton(description: Strings.backTitle, image: "back")
        backButton.position = CGPoint(x: rightX, y: -20.0)
        backButton.action = {
            self.gameViewController?.showMainMenu()
        }
        self.addChild(backButton)
    }
}
