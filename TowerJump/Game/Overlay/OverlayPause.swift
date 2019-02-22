//
//  OverlayPause.swift
//  TowerJump
//
//  Created by Oliver Brehm on 03.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayPause: Overlay {
    let resourceView = ResourceView()

    func setup(game: Game) {
        super.setup(size: game.frame.size, width: 0.8)
        
        let backButton = Button(caption: "Resume")
        backButton.position = CGPoint(x: 80.0, y: 80.0)
        backButton.action = {
            game.resume()
        }
        self.addChild(backButton)
        
        let retryButton = Button(caption: "R")
        retryButton.size = CGSize(width: 40.0, height: 40.0)
        retryButton.position = CGPoint(x: 50.0, y: 0.0)
        retryButton.action = {
            game.resetGame()
        }
        self.addChild(retryButton)
        
        let exitButton = Button(caption: "E")
        exitButton.size = CGSize(width: 40.0, height: 40.0)
        exitButton.position = CGPoint(x: 110.0, y: 0.0)
        exitButton.action = {
            game.gameViewController?.showMainMenu()
        }
        self.addChild(exitButton)
        
        resourceView.setup(position: CGPoint(x: 80.0, y: -90.0))
        self.addChild(resourceView)
    }
    
    override func show() {
        self.resourceView.updateValues()
        super.show()
    }
}
