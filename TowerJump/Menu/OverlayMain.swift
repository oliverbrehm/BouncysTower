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
        startButton.position = CGPoint(x: 60.0, y: 100.0)
        startButton.Action = {
            menu.GameViewController?.ShowGame()
        }
        self.addChild(startButton)
        
        let creditsButton = Button(caption: "Settings")
        creditsButton.position = CGPoint(x: 60.0, y: 0.0)
        creditsButton.Action = {
            menu.GameViewController?.ShowCredits()
        }
        self.addChild(creditsButton)
        
        let resourceView = ResourceView()
        resourceView.Setup(position: CGPoint(x: 60.0, y: -90.0))
        self.addChild(resourceView)
    }
}
