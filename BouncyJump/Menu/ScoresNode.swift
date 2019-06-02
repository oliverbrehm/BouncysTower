//
//  ScoresScene.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 25.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ScoreNode: SKNode {
    override init() {
        super.init()
        
        var currentY = 100.0
        let dY = 20.0
        
        let titleLabel = SKLabelNode(fontNamed: Constants.fontName)
        titleLabel.position = CGPoint(x: 0.0, y: currentY + 35.0)
        titleLabel.fontColor = Constants.colors.menuForeground
        titleLabel.fontSize = 30.0
        titleLabel.text = "SCORES"
        titleLabel.zPosition = NodeZOrder.label
        self.addChild(titleLabel)
        
        let scores = Score.standard.scores
        if(scores.isEmpty) {
            let emptyLabel = SKLabelNode(fontNamed: Constants.fontName)
            emptyLabel.position = CGPoint(x: 0.0, y: currentY)
            emptyLabel.fontColor = SKColor.white
            emptyLabel.fontSize = 15.0
            emptyLabel.text = "No scores yet..."
            emptyLabel.zPosition = NodeZOrder.label
            self.addChild(emptyLabel)
            
            currentY -= dY
        } else {
            for index in scores.indices {
                let score = scores[index]
                let scoreLabel = SKLabelNode(fontNamed: Constants.fontName)
                scoreLabel.position = CGPoint(x: 0.0, y: currentY)
                scoreLabel.fontColor = SKColor.white
                scoreLabel.fontSize = 15.0
                scoreLabel.zPosition = NodeZOrder.label
                scoreLabel.text = "\(index + 1): \(score)"
                self.addChild(scoreLabel)
                
                if let mostRecentRank = Score.standard.mostRecentRank, index == mostRecentRank {
                    scoreLabel.run(SKAction.repeatForever(SKAction.sequence([
                        SKAction.colorize(with: Constants.colors.menuForeground, colorBlendFactor: 1.0, duration: 0.3),
                        SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.3)
                    ])))
                    scoreLabel.fontSize = 20.0
                }
                
                currentY -= dY
            }
        }
        
        let gameCenterButton = IconDescriptionButton(description: "GAME CENTER", image: "options")
        gameCenterButton.position = CGPoint(x: 0, y: currentY - dY)
        gameCenterButton.action = {
            GameCenterManager.standard.showLeaderboard()
        }
        self.addChild(gameCenterButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
