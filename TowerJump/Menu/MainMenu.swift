//
//  File.swift
//  TowerJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class MainMenu : SKScene
{
    public var GameViewController : GameViewController?
    
    override func didMove(to view: SKView) {
        let startButton = Button(caption: "Start Game")
        startButton.position = CGPoint(x: 0.0, y: 50.0)
        startButton.Action = {
            self.GameViewController?.ShowGame()
        }

        self.addChild(startButton)
        
        let creditsButton = Button(caption: "Credits")
        creditsButton.position = CGPoint(x: 0.0, y: -50.0)
        creditsButton.Action = {
            self.GameViewController?.ShowCredits()
        }
        
        self.addChild(creditsButton)
    }
}
