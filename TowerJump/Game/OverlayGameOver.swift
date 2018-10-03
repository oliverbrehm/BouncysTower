//
//  OverlayGameOver.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayGameOver : SKSpriteNode
{
    public var Game : Game?
    
    private let label = SKLabelNode(text: "")
    
    init() {
        super.init(texture: nil, color: SKColor.white, size: CGSize.zero)
        
        let backButton = Button(caption: "Back")
        backButton.position = CGPoint(x: 0.0, y: 20.0)
        backButton.Action = {
            self.Game?.GameViewController?.ShowMainMenu()
        }
        self.addChild(backButton)
        
        let retryButton = Button(caption: "Retry")
        retryButton.position = CGPoint(x: 0.0, y: -80.0)
        retryButton.Action = {
            self.Game?.resetGame()
        }
        self.addChild(retryButton)
        
        self.label.position = CGPoint(x: 0.0, y: 75.0)
        self.label.fontSize = 24.0
        self.label.fontColor = SKColor.red
        self.addChild(self.label)
        
        self.isHidden = true
        
        self.zPosition = NodeZOrder.Overlay
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func Message(score: Int) -> String
    {
        return "GAME OVER | Score: \(score)"
    }
    
    func Show(score: Int)
    {
        self.label.text = self.Message(score: score)
        self.isHidden = false
    }
    
    func Hide()
    {
        self.isHidden = true
    }
}
