//
//  MainMenuOverlay.swift
//  TowerJump
//
//  Created by Oliver Brehm on 23.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayMainMenu : Overlay
{
    func Setup(menu: MainMenu) {
        super.Setup(scene: menu, width: 0.65)
        
        let startButton = Button(caption: "Start Game")
        startButton.position = CGPoint(x: 60.0, y: 50.0)
        startButton.Action = {
            menu.GameViewController?.ShowGame()
        }
        
        self.addChild(startButton)
        
        let creditsButton = Button(caption: "Credits")
        creditsButton.position = CGPoint(x: 60.0, y: -50.0)
        creditsButton.Action = {
            menu.GameViewController?.ShowCredits()
        }
        
        self.addChild(creditsButton)
    }
}
