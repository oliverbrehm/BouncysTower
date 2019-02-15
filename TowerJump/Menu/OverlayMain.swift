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
    func setup(size: CGSize, menu: Main) {
        super.setup(size: size, width: 0.65)
        
        let startButton = Button(caption: "Start Game")
        startButton.position = CGPoint(x: 60.0, y: 100.0)
        startButton.action = {
            menu.gameViewController?.showGame()
        }
        self.addChild(startButton)
        
        let creditsButton = Button(caption: "Settings")
        creditsButton.position = CGPoint(x: 60.0, y: 0.0)
        creditsButton.action = {
            menu.gameViewController?.showCredits()
        }
        self.addChild(creditsButton)
        
        let resourceView = ResourceView()
        resourceView.setup(position: CGPoint(x: 60.0, y: -90.0))
        self.addChild(resourceView)
    }
}
