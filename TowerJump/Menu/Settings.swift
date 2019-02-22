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
        let infoLabel = SKLabelNode(text: "Made by Oliver Brehm")
        infoLabel.fontColor = SKColor.green
        infoLabel.fontName = "AmericanTypewriter-Bold"
        infoLabel.fontSize = 28.0
        infoLabel.position = CGPoint(x: 0.0, y: 100.0)
        infoLabel.zPosition = NodeZOrder.label
        self.addChild(infoLabel)
        
        let tutorialButton = Button(caption: "Tutorial")
        tutorialButton.position = CGPoint(x: 0.0, y: 0.0)
        tutorialButton.action = {
            self.gameViewController?.showTutorial()
        }
        self.addChild(tutorialButton)
        
        let backButton = Button(caption: "Back")
        backButton.position = CGPoint(x: 0.0, y: -100.0)
        backButton.action = {
            self.gameViewController?.showMainMenu()
        }
        self.addChild(backButton)
    }
}
