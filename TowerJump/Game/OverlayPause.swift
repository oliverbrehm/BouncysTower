//
//  OverlayPause.swift
//  TowerJump
//
//  Created by Oliver Brehm on 03.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayPause : Overlay
{
    func Setup(game: Game) {
        super.Setup(scene: game, width: 0.8)
        
        let backButton = Button(caption: "Resume")
        backButton.position = CGPoint(x: 60.0, y: 80.0)
        backButton.Action = {
            game.Resume()
        }
        self.addChild(backButton)
        
        let retryButton = Button(caption: "Retry")
        retryButton.position = CGPoint(x: 60.0, y: 0.0)
        retryButton.Action = {
            game.resetGame()
        }
        self.addChild(retryButton)
        
        let exitButton = Button(caption: "Exit")
        exitButton.position = CGPoint(x: 60.0, y: -80.0)
        exitButton.Action = {
            game.GameViewController?.ShowMainMenu()
        }
        self.addChild(exitButton)
    }
}
