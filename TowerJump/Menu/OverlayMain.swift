//
//  MainMenuOverlay.swift
//  TowerJump
//
//  Created by Oliver Brehm on 23.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayMain: Overlay {
    func setup(size: CGSize, menu: Main) {
        super.setup(size: size, width: 0.65)
        
        let startButton = IconButton(image: "play")
        startButton.position = CGPoint(x: 60.0, y: 90.0)
        startButton.action = {
            menu.gameViewController?.showGame()
        }
        self.addChild(startButton)
        
        let creditsButton = IconButton(image: "options")
        creditsButton.position = CGPoint(x: 60.0, y: 10.0)
        creditsButton.action = {
            menu.gameViewController?.showSettings()
        }
        self.addChild(creditsButton)
        
        let resourceView = ResourceView()
        resourceView.setup(position: CGPoint(x: 60.0, y: -90.0))
        self.addChild(resourceView)
    }
}
