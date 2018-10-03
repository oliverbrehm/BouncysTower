//
//  OverlayPause.swift
//  TowerJump
//
//  Created by Oliver Brehm on 03.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayPause : SKSpriteNode
{
    public var Game : Game?
    
    init() {
        super.init(texture: nil, color: SKColor.white, size: CGSize.zero)
        
        let backButton = Button(caption: "Resume")
        backButton.position = CGPoint(x: 0.0, y: 80.0)
        backButton.Action = {
            self.Game?.Resume()
        }
        self.addChild(backButton)
        
        let retryButton = Button(caption: "Retry")
        retryButton.position = CGPoint(x: 0.0, y: 0.0)
        retryButton.Action = {
            self.Game?.resetGame()
        }
        self.addChild(retryButton)
        
        let exitButton = Button(caption: "Exit")
        exitButton.position = CGPoint(x: 0.0, y: -80.0)
        exitButton.Action = {
            self.Game?.GameViewController?.ShowMainMenu()
        }
        self.addChild(exitButton)
        
        self.isHidden = true

        self.zPosition = NodeZOrder.Overlay
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func Show()
    {
        self.isHidden = false
    }
    
    func Hide()
    {
        self.isHidden = true
    }
}
