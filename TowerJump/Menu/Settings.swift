//
//  Credits.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Settings : SKScene
{
    public var GameViewController : GameViewController?
    
    override func didMove(to view: SKView) {
        let infoLabel = SKLabelNode(text: "Made by Oliver Brehm")
        infoLabel.fontColor = SKColor.green
        infoLabel.fontName = "AmericanTypewriter-Bold"
        infoLabel.fontSize = 28.0
        infoLabel.position = CGPoint(x: 0.0, y: 100.0)
        infoLabel.zPosition = NodeZOrder.Label
        self.addChild(infoLabel)
        
        let tutorialButton = Button(caption: "Tutorial")
        tutorialButton.position = CGPoint(x: 0.0, y: 0.0)
        tutorialButton.Action = {
            self.GameViewController?.ShowTutorial()
        }
        self.addChild(tutorialButton)
        
        let backButton = Button(caption: "Back")
        backButton.position = CGPoint(x: 0.0, y: -100.0)
        backButton.Action = {
            self.GameViewController?.ShowMainMenu()
        }
        self.addChild(backButton)
    }
}
