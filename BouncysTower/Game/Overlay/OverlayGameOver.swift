//
//  OverlayGameOver.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

extension SKLabelNode {
    
    var top: CGFloat {
        return position.y + frame.size.height / 2.0
    }
    
    var bottom: CGFloat {
        return position.y - frame.size.height / 2.0
    }
    
    var height: CGFloat {
        return frame.size.height
    }
}

class ScoreView: Button {
    private let margin: CGFloat = 10.0

    private let scoreLabel = SKLabelNode(fontNamed: Font.fontName)
    private let rankLabel = SKLabelNode(fontNamed: Font.fontName)
    private let platformNumberLabel = SKLabelNode(fontNamed: Font.fontName)
    private let longestComboLabel = SKLabelNode(fontNamed: Font.fontName)
    
    private let highlightAction = SKAction.repeatForever(SKAction.sequence([
       SKAction.colorize(with: Colors.menuForeground, colorBlendFactor: 1.0, duration: 0.3),
       SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.3)
    ]))
    
    init() {
        super.init(size: CGSize.zero)
        
        scoreLabel.position = CGPoint(x: 0.0, y: 0)
        scoreLabel.fontSize = 24.0
        scoreLabel.zPosition = NodeZOrder.label
        addChild(scoreLabel)
        
        rankLabel.fontSize = 10.0
        rankLabel.zPosition = NodeZOrder.label
        rankLabel.text = Strings.Scores.rankLabel
        rankLabel.position = CGPoint(x: 0.0, y: scoreLabel.bottom - margin - rankLabel.height / 2.0)
        addChild(rankLabel)
        
        platformNumberLabel.fontSize = 16.0
        platformNumberLabel.zPosition = NodeZOrder.label
        platformNumberLabel.position = CGPoint(x: 0.0, y: scoreLabel.top + 4 * margin + platformNumberLabel.height / 2.0)
        addChild(platformNumberLabel)
        
        longestComboLabel.fontSize = 16.0
        longestComboLabel.zPosition = NodeZOrder.label
        longestComboLabel.position = CGPoint(x: 0.0, y: platformNumberLabel.top + 2 * margin + platformNumberLabel.height / 2.0)
        addChild(longestComboLabel)
        
        action = {
            if let game = self.scene as? Game {
                game.gameViewController?.showSettings()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(position: CGPoint, score: Int, rank: Int?, platformNumber: Int, isBestPlatformNumber: Bool, longestCombo: Int, isBestCombo: Bool) {
        rankLabel.removeAllActions()
        platformNumberLabel.removeAllActions()
        longestComboLabel.removeAllActions()

        scoreLabel.color = SKColor.white
        rankLabel.color = SKColor.white
        platformNumberLabel.color = SKColor.white
        longestComboLabel.color = SKColor.white
        
        self.position = position
        
        scoreLabel.text = "Score: \(score)"

        if let r = rank {
            rankLabel.text = (r == 0) ? Strings.Scores.newHighscoreLabel : "\(Strings.Scores.rankLabel) \(r + 1)"
            rankLabel.isHidden = false
            rankLabel.run(highlightAction)
        } else {
            rankLabel.isHidden = true
        }
        
        platformNumberLabel.text = "Platform: \(platformNumber)"
        if isBestPlatformNumber {
            platformNumberLabel.run(highlightAction)
        }
        
        longestComboLabel.text = "\(Strings.Scores.longestComboLabel): \(longestCombo)"
        if isBestCombo {
            longestComboLabel.run(highlightAction)
        }
        
        self.size = CGSize(width: scoreLabel.frame.size.width, height: 2 * scoreLabel.frame.size.height + margin)
    }
}

class OverlayGameOver: Overlay {
    private let scoreView = ScoreView()
    private let resourceView = ResourceView()

    func setup(game: Game) {
        super.setup(size: game.frame.size, width: 0.8)
        
        let gameOverLabel = SKLabelNode(fontNamed: Font.fontName)
        gameOverLabel.position = CGPoint(x: 80.0, y: 130.0)
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 24.0
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.zPosition = NodeZOrder.label
        addChild(gameOverLabel)
        
        let backButton = IconButton(image: "back")
        backButton.position = CGPoint(x: 120.0, y: -20.0)
        backButton.action = {
            game.gameViewController?.showMainMenu()
        }
        self.addChild(backButton)
        
        let retryButton = IconButton(image: "retry")
        retryButton.position = CGPoint(x: 40.0, y: -20.0)
        retryButton.action = {
            game.resetGame()
        }
        self.addChild(retryButton)
        
        self.addChild(scoreView)
        
        resourceView.setup(position: CGPoint(x: 80.0, y: -110.0))
        self.addChild(resourceView)
    }
    
    func show(score: Int, rank: Int?, platformNumber: Int, isBestPlatformNumber: Bool, longestCombo: Int, isBestCombo: Bool) {
        self.resourceView.updateValues()
        self.scoreView.setup(
            position: CGPoint(x: 80.0, y: 40.0),
            score: score, rank: rank,
            platformNumber: platformNumber, isBestPlatformNumber: isBestPlatformNumber,
            longestCombo: longestCombo, isBestCombo: isBestCombo)
        
        super.show()
    }
}
