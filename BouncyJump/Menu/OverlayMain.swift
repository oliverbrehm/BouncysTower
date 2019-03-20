//
//  MainMenuOverlay.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 23.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayMain: Overlay {
    func setup(size: CGSize, menu: Main) {
        super.setup(size: size, width: 0.65)
        
        let startButton = IconDescriptionButton(description: "PLAY", image: "play")
        startButton.position = CGPoint(x: 60.0, y: 90.0)
        startButton.action = {
            menu.gameViewController?.showGame()
        }
        self.addChild(startButton)
        
        let creditsButton = IconDescriptionButton(description: "SCORES", image: "options")
        creditsButton.position = CGPoint(x: 60.0, y: 10.0)
        creditsButton.action = {
            menu.gameViewController?.showSettings()
        }
        self.addChild(creditsButton)
        
        let resourceView = ResourceView()
        resourceView.setup(position: CGPoint(x: 60.0, y: -90.0), shopDelegate: menu)
        self.addChild(resourceView)
    }
}
