//
//  ScoresScene.swift
//  BouncysTower
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
        
        let titleLabel = SKLabelNode(fontNamed: Font.fontName)
        titleLabel.position = CGPoint(x: 0.0, y: currentY + 35.0)
        titleLabel.fontColor = Colors.menuForeground
        titleLabel.fontSize = 30.0
        titleLabel.text = "SCORES"
        titleLabel.zPosition = NodeZOrder.label
        self.addChild(titleLabel)
        
        let scores = Score.standard.scores
        if scores.isEmpty {
            let emptyLabel = SKLabelNode(fontNamed: Font.fontName)
            emptyLabel.position = CGPoint(x: 0.0, y: currentY)
            emptyLabel.fontColor = SKColor.white
            emptyLabel.fontSize = 15.0
            emptyLabel.text = Strings.MenuSettings.noScoresMessage
            emptyLabel.zPosition = NodeZOrder.label
            self.addChild(emptyLabel)
            
            currentY -= dY
        } else {
            for index in scores.indices {
                let score = scores[index]
                let scoreLabel = SKLabelNode(fontNamed: Font.fontName)
                scoreLabel.position = CGPoint(x: 0.0, y: currentY)
                scoreLabel.fontColor = SKColor.white
                scoreLabel.fontSize = 15.0
                scoreLabel.zPosition = NodeZOrder.label
                scoreLabel.text = "\(index + 1): \(score)"
                self.addChild(scoreLabel)
                
                if let mostRecentRank = Score.standard.mostRecentRank, index == mostRecentRank {
                    scoreLabel.run(SKAction.repeatForever(SKAction.sequence([
                        SKAction.colorize(with: Colors.menuForeground, colorBlendFactor: 1.0, duration: 0.3),
                        SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.3)
                    ])))
                    scoreLabel.fontSize = 20.0
                }
                
                currentY -= dY
            }
        }
        
        let highestJumpLabel = SKLabelNode(fontNamed: Font.fontName)
        highestJumpLabel.position = CGPoint(x: 0.0, y: currentY - dY)
        highestJumpLabel.fontColor = Colors.menuForeground
        highestJumpLabel.fontSize = 15.0
        highestJumpLabel.zPosition = NodeZOrder.label
        highestJumpLabel.text = "\(Strings.Scores.highestJumpLabel): \(Score.standard.highestJump)"
        self.addChild(highestJumpLabel)

        let longestComboLabel = SKLabelNode(fontNamed: Font.fontName)
        longestComboLabel.position = CGPoint(x: 0.0, y: currentY - 2 * dY)
        longestComboLabel.fontColor = Colors.menuForeground
        longestComboLabel.fontSize = 15.0
        longestComboLabel.zPosition = NodeZOrder.label
        longestComboLabel.text = "\(Strings.Scores.longestComboLabel): \(Score.standard.longestCombo)"
        self.addChild(longestComboLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
