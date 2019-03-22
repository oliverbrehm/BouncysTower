//
//  OverlayGameOver.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ScoreView: Button {
    private let margin: CGFloat = 5.0

    private let scoreLabel = SKLabelNode(fontNamed: Constants.fontName)
    private let rankLabel = SKLabelNode(fontNamed: Constants.fontName)
    
    init() {
        super.init(size: CGSize.zero)
        
        self.scoreLabel.position = CGPoint(x: 0.0, y: margin / 2.0)
        self.scoreLabel.fontSize = 24.0
        self.scoreLabel.fontColor = SKColor.white
        self.scoreLabel.zPosition = NodeZOrder.label
        self.addChild(self.scoreLabel)
        
        self.rankLabel.fontSize = 10.0
        self.rankLabel.fontColor = SKColor.white
        self.scoreLabel.zPosition = NodeZOrder.label
        self.rankLabel.text = "RANK"
        self.rankLabel.position = CGPoint(x: 0.0, y: -margin / 2.0 - rankLabel.frame.size.height)
        self.addChild(self.rankLabel)
        
        self.action = {
            if let game = self.scene as? Game {
                game.gameViewController?.showSettings()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(position: CGPoint, score: Int, rank: Int?) {
        self.position = position
        
        self.scoreLabel.text = "Score: \(score)"

        if let r = rank {
            self.rankLabel.text = (r == 0) ? "NEW HIGHSCORE" : "RANK \(r + 1)"
            self.rankLabel.isHidden = false
            self.rankLabel.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.colorize(with: Constants.colors.menuForeground, colorBlendFactor: 1.0, duration: 0.3),
                SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.3)
                ])))
        } else {
            self.rankLabel.isHidden = true
        }
        
        self.size = CGSize(width: scoreLabel.frame.size.width, height: 2 * scoreLabel.frame.size.height + margin)
    }
}

class OverlayGameOver: Overlay {
    private let scoreView = ScoreView()
    private let resourceView = ResourceView()

    func setup(game: Game) {
        super.setup(size: game.frame.size, width: 0.8)
        
        let gameOverLabel = SKLabelNode(fontNamed: Constants.fontName)
        gameOverLabel.position = CGPoint(x: 80.0, y: 100.0)
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 24.0
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.zPosition = NodeZOrder.label
        addChild(gameOverLabel)
        
        let backButton = IconButton(image: "back")
        backButton.position = CGPoint(x: 110.0, y: 0.0)
        backButton.action = {
            game.gameViewController?.showMainMenu()
        }
        self.addChild(backButton)
        
        let retryButton = IconButton(image: "retry")
        retryButton.position = CGPoint(x: 50.0, y: 0.0)
        retryButton.action = {
            game.resetGame()
        }
        self.addChild(retryButton)
        
        self.addChild(scoreView)
        
        resourceView.setup(position: CGPoint(x: 80.0, y: -90.0))
        self.addChild(resourceView)
    }
    
    func show(score: Int, rank: Int?) {
        self.resourceView.updateValues()
        self.scoreView.setup(position: CGPoint(x: 80.0, y: 60.0), score: score, rank: rank)
        
        super.show()
    }
}
