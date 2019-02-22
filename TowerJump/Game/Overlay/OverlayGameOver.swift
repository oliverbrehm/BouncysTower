//
//  OverlayGameOver.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayGameOver: Overlay {
    private let scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    let resourceView = ResourceView()

    func setup(game: Game) {
        super.setup(size: game.frame.size, width: 0.8)
        
        let gameOverLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        gameOverLabel.position = CGPoint(x: 80.0, y: 100.0)
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 24.0
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.zPosition = NodeZOrder.label
        addChild(gameOverLabel)
        
        self.scoreLabel.position = CGPoint(x: 80.0, y: 60.0)
        self.scoreLabel.fontSize = 24.0
        self.scoreLabel.fontColor = SKColor.white
        self.scoreLabel.zPosition = NodeZOrder.label
        self.addChild(self.scoreLabel)
        
        let backButton = Button(caption: "B")
        backButton.size = CGSize(width: 40.0, height: 40.0)
        backButton.position = CGPoint(x: 50.0, y: 0.0)
        backButton.action = {
            game.gameViewController?.showMainMenu()
        }
        self.addChild(backButton)
        
        let retryButton = Button(caption: "R")
        retryButton.size = CGSize(width: 40.0, height: 40.0)
        retryButton.position = CGPoint(x: 110.0, y: 0.0)
        retryButton.action = {
            game.resetGame()
        }
        self.addChild(retryButton)
        
        resourceView.setup(position: CGPoint(x: 80.0, y: -90.0))
        self.addChild(resourceView)
    }
    
    func show(score: Int) {
        self.scoreLabel.text = "Score: \(score)"
        self.resourceView.updateValues()
        super.show()
    }
}
