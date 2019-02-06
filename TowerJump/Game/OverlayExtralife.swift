//
//  OverlayExtralife.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayExtralife : Overlay
{
    private let lifeSprite = SKSpriteNode(imageNamed: "extralife")
    
    func Setup(game: MainGame) {
        super.Setup(size: game.frame.size, width: 0.8)
        
        let label = SKLabelNode(text: "Use extralife?")
        label.fontSize = 20.0
        label.fontName = "AmericanTypewriter-Bold"
        label.fontColor = SKColor.red
        label.position = CGPoint(x: 60.0, y: 100.0)
        label.zPosition = NodeZOrder.Button
        self.addChild(label)
        
        self.lifeSprite.position = CGPoint(x: 60.0, y: 0.0)
        self.lifeSprite.size = CGSize(width: 60.0, height: 60.0)
        self.lifeSprite.zPosition = NodeZOrder.Button
        self.lifeSprite.zPosition = NodeZOrder.Button
        self.addChild(lifeSprite)
        
        let useExtralifeButton = Button(caption: "GO!")
        useExtralifeButton.position = CGPoint(x: 60.0, y: -80.0)
        useExtralifeButton.Action = {
            self.lifeSprite.removeAllActions()
            game.UseExtralife()
            self.Hide()
        }
        self.addChild(useExtralifeButton)
    }
    
    func Start(game: MainGame) {
        self.lifeSprite.removeAllActions()
        self.lifeSprite.setScale(1.0)
        self.lifeSprite.run(SKAction.sequence([
            SKAction.scale(to: 0.0, duration: 3.5),
            SKAction.run {
                game.GameOver()
                self.Hide()
            }
        ]))
    }
}
