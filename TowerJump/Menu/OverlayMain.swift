//
//  MainMenuOverlay.swift
//  TowerJump
//
//  Created by Oliver Brehm on 23.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayMain : Overlay
{
    func Setup(size: CGSize, menu: Main) {
        super.Setup(size: size, width: 0.65)
        
        let startButton = Button(caption: "Start Game")
        startButton.position = CGPoint(x: 60.0, y: 80.0)
        startButton.Action = {
            menu.GameViewController?.ShowGame()
        }
        self.addChild(startButton)
        
        let creditsButton = Button(caption: "Settings")
        creditsButton.position = CGPoint(x: 60.0, y: -20.0)
        creditsButton.Action = {
            menu.GameViewController?.ShowCredits()
        }
        self.addChild(creditsButton)

        let lifeSprite = SKSpriteNode(imageNamed: "extralife")
        lifeSprite.position = CGPoint(x: 40.0, y: -120.0)
        lifeSprite.size = CGSize(width: 30.0, height: 30.0)
        lifeSprite.zPosition = NodeZOrder.Button
        let labelExtralives = SKLabelNode(text: "x \(Config.Default.ExtraLives)")
        labelExtralives.fontSize = 20.0
        labelExtralives.fontName = "AmericanTypewriter-Bold"
        labelExtralives.fontColor = SKColor.darkGray
        labelExtralives.position = CGPoint(x: 40.0, y: -10.0)
        lifeSprite.addChild(labelExtralives)
        self.addChild(lifeSprite)
    }
}
