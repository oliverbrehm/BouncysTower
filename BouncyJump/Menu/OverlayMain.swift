//
//  MainMenuOverlay.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 23.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayMain: Overlay {
    private let resourceView = ResourceView()
    
    private lazy var highlight = SKSpriteNode(color: SKColor.white,
                                              size: CGSize(width: resourceView.size.width * 1.2, height: resourceView.size.height * 1.2))

    func setup(size: CGSize, menu: Main) {
        super.setup(size: size, width: 0.65)
        
        let startButton = IconDescriptionButton(description: Strings.MenuMain.startTitle, image: "play")
        startButton.position = CGPoint(x: 60.0, y: 90.0)
        startButton.action = {
            menu.gameViewController?.showGame()
        }
        self.addChild(startButton)
        
        let creditsButton = IconDescriptionButton(description: Strings.MenuMain.secondMenuTitle, image: "options")
        creditsButton.position = CGPoint(x: 60.0, y: 10.0)
        creditsButton.action = {
            menu.gameViewController?.showSettings()
        }
        self.addChild(creditsButton)
        
        resourceView.setup(position: CGPoint(x: 60.0, y: -90.0), shopDelegate: menu)
        self.addChild(resourceView)
    }
    
    func highlightResourceView() {
        highlight.alpha = 0.0
        resourceView.addChild(highlight)
        
        highlight.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.4, duration: 0.8),
            SKAction.fadeOut(withDuration: 0.8)
        ])))
    }
    
    func stopHighlightingResourceView() {
        highlight.removeAllActions()
        highlight.removeFromParent()
    }
}
