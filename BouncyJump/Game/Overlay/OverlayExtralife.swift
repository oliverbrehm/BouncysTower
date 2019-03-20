//
//  OverlayExtralife.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class OverlayExtralife: Overlay {
    private let lifeSprite = SKSpriteNode(imageNamed: "extralife")
    
    func setup(game: MainGame) {
        super.setup(size: game.frame.size, width: 0.6)
        
        let label = SKLabelNode(text: "Use extralife?")
        label.fontSize = 20.0
        label.fontName = Constants.fontName
        label.fontColor = SKColor.white
        label.position = CGPoint(x: 80.0, y: 100.0)
        label.zPosition = NodeZOrder.button
        self.addChild(label)
        
        self.lifeSprite.position = CGPoint(x: 80.0, y: 0.0)
        self.lifeSprite.size = CGSize(width: 60.0, height: 60.0)
        self.lifeSprite.zPosition = NodeZOrder.button
        self.lifeSprite.zPosition = NodeZOrder.button
        self.addChild(lifeSprite)
        
        let useExtralifeButton = IconButton(image: "play")
        useExtralifeButton.position = CGPoint(x: 80.0, y: -80.0)
        useExtralifeButton.action = {
            self.lifeSprite.removeAllActions()
            game.useExtralife()
            self.hide()
        }
        self.addChild(useExtralifeButton)
    }
    
    func start(game: MainGame) {
        self.lifeSprite.removeAllActions()
        self.lifeSprite.setScale(1.0)
        self.lifeSprite.run(SKAction.sequence([
            SKAction.scale(to: 0.0, duration: 3.5),
            SKAction.run {
                game.gameOver()
                self.hide()
            }
        ]))
    }
}
