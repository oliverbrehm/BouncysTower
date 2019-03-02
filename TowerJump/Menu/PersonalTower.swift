//
//  PrivateTower.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class PersonalTower: SKNode {
    private let towerImage = SKSpriteNode(imageNamed: "menuTower")
    private let bricksLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    private let rowsLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    private let buildRowButton = IconButton(image: "build")
    private let player = Player()
    private let towerTop = SKSpriteNode(imageNamed: "towerTop")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        towerImage.zPosition = NodeZOrder.background + 0.01
        towerImage.size = CGSize(width: 200.0, height: 200.0)
        towerImage.position = CGPoint(x: 0.0, y: 10.0 + towerImage.size.height / 2.0)
        
        towerTop.size = CGSize(
            width: towerImage.size.width * 1.2,
            height: towerImage.size.height * 0.3)
        towerTop.zPosition = NodeZOrder.background + 0.02
        
        player.physicsBody?.isDynamic = false
        
        buildRowButton.action = {
            TowerBricks.standard.buildRow()
            self.update()
        }
        
        bricksLabel.zPosition = NodeZOrder.world
        bricksLabel.fontColor = SKColor.blue
        bricksLabel.fontSize = 16.0
        
        rowsLabel.zPosition = NodeZOrder.world
        rowsLabel.fontColor = SKColor.blue
        rowsLabel.fontSize = 18.0
        
        self.update()
    }
    
    func update() {
        self.removeAllChildren()
        
        self.addChild(towerImage)
        
        let towerWidth = towerImage.size.width
        let brickWidth = towerWidth / CGFloat(TowerBricks.numberOfBricksInRow)
        let brickHeight = brickWidth * (2.0 / 3.0)
        let brickSize = CGSize(width: brickWidth, height: brickHeight)
        
        var y: CGFloat = 10.0 + towerImage.size.height
        
        // bricks in tower
        let rows = TowerBricks.standard.rows
        rowsLabel.text = "Tower height: \(rows.count)"
        for row in rows {
            var x: CGFloat = -towerImage.size.width / 2.0
            for brick in row {
                let brickNode = SKSpriteNode(imageNamed: brick.textureName)
                brickNode.zPosition = NodeZOrder.world
                brickNode.size = brickSize
                brickNode.position = CGPoint(x: x + brickWidth / 2.0, y: y + brickHeight / 2.0)
                self.addChild(brickNode)
                x += brickWidth
            }
            y += brickHeight
        }
        
        let bricks = TowerBricks.standard.bricks
        bricksLabel.text = "Bricks left: \(bricks.count)"
        
        player.position = CGPoint(x: 0.0, y: y + 2.0 + player.size.height / 2.0)
        self.addChild(player)
        
        towerTop.position = player.position
        self.addChild(towerTop)
        
        buildRowButton.position = CGPoint(x: 0.0, y: player.position.y + player.size.height / 2.0 + 10.0 + buildRowButton.size.height / 2.0)
        self.addChild(buildRowButton)
        
        rowsLabel.position = CGPoint(x: 0.0, y: buildRowButton.position.y + buildRowButton.size.height / 2.0 + 10.0)
        self.addChild(rowsLabel)
        
        bricksLabel.position = CGPoint(x: 0.0, y: rowsLabel.position.y + rowsLabel.frame.size.height / 2.0 + 10.0)
        self.addChild(bricksLabel)
        
        // bricks in store
        y = player.position.y - player.size.height / 2.0
        let x = player.position.x - player.size.width / 2.0 - brickWidth / 2.0 - 35.0
        for brick in bricks {
            let brickNode = SKSpriteNode(imageNamed: brick.textureName)
            brickNode.alpha = 0.7
            brickNode.size = CGSize(width: brickWidth, height: brickHeight)
            brickNode.zPosition = NodeZOrder.world
            self.addChild(brickNode)
            brickNode.position = CGPoint(x: x, y: y + brickWidth / 2.0)
            
            y += brickHeight
        }
    }
}
