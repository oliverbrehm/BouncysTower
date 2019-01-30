//
//  Advertising.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Advertising : SKScene
{
    private var secondsLeft = 2
    
    public func Execute(completion: @escaping () -> Void) { // TODO what is @escaping
        let infoLabel = SKLabelNode(text: "\(self.secondsLeft)")
        infoLabel.fontColor = SKColor.green
        infoLabel.fontName = "AmericanTypewriter-Bold"
        infoLabel.fontSize = 28.0
        infoLabel.position = CGPoint(x: 0.0, y: -100.0)
        infoLabel.zPosition = NodeZOrder.Label
        self.addChild(infoLabel)
        
        let closeButton = Button(caption: "Close")
        closeButton.position = CGPoint(x: 0.0, y: -100.0)
        closeButton.isHidden = true
        closeButton.Action = {
            completion()
        }
        self.addChild(closeButton)
        
        infoLabel.run(SKAction.repeat(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                self.secondsLeft = self.secondsLeft - 1
                infoLabel.text = "\(self.secondsLeft)"
                
                if(self.secondsLeft == 0) {
                    infoLabel.isHidden = true
                    closeButton.isHidden = false
                }
            }
        ]), count: self.secondsLeft))
    }
}
