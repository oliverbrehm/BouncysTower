//
//  OverlayGameOver.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayGameOver : Overlay
{
    
    private let label = SKLabelNode(text: "")
    
    func Setup(game: Game) {
        super.Setup(scene: game)
        
        let backButton = Button(caption: "Back")
        backButton.position = CGPoint(x: 40.0, y: 20.0)
        backButton.Action = {
            game.GameViewController?.ShowMainMenu()
        }
        self.addChild(backButton)
        
        let retryButton = Button(caption: "Retry")
        retryButton.position = CGPoint(x: 40.0, y: -80.0)
        retryButton.Action = {
            game.resetGame()
        }
        self.addChild(retryButton)
        
        self.label.position = CGPoint(x: 40.0, y: 75.0)
        self.label.fontSize = 24.0
        self.label.fontColor = SKColor.red
        self.addChild(self.label)
    }
    
    private func Message(score: Int) -> String
    {
        return "GAME OVER | Score: \(score)"
    }
    
    func Show(score: Int)
    {
        self.label.text = self.Message(score: score)
        super.Show()
    }
}
