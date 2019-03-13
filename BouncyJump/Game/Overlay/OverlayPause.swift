//
//  OverlayPause.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 03.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayPause: Overlay {
    let resourceView = ResourceView()

    func setup(game: Game) {
        super.setup(size: game.frame.size, width: 0.6)
        
        let pausedLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        pausedLabel.position = CGPoint(x: 80.0, y: 120.0)
        pausedLabel.text = "PAUSED"
        pausedLabel.fontSize = 24.0
        pausedLabel.fontColor = SKColor.white
        pausedLabel.zPosition = NodeZOrder.label
        self.addChild(pausedLabel)
        
        let backButton = IconButton(image: "play")
        backButton.position = CGPoint(x: 80.0, y: 80.0)
        backButton.action = {
            game.resume()
        }
        self.addChild(backButton)
        
        let retryButton = IconButton(image: "retry")
        retryButton.position = CGPoint(x: 50.0, y: 0.0)
        retryButton.action = {
            game.resetGame()
        }
        self.addChild(retryButton)
        
        let exitButton = IconButton(image: "back")
        exitButton.position = CGPoint(x: 110.0, y: 0.0)
        exitButton.action = {
            game.gameViewController?.showMainMenu()
        }
        self.addChild(exitButton)
        
        resourceView.setup(position: CGPoint(x: 60.0, y: -90.0))
        self.addChild(resourceView)
    }
    
    override func show() {
        self.resourceView.updateValues()
        super.show()
    }
}
