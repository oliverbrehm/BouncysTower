//
//  PrivateTower.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

protocol PersonalTowerDelegate {
    func towerViewModeStarted()
}

class PersonalTower: SKNode {
    private let brickWidth: CGFloat = 42.0
    private let brickHeight: CGFloat = 28.0
    
    private var brickSize: CGSize {
        return CGSize(width: brickWidth, height: brickHeight)
    }
    
    private let towerImage = SKSpriteNode(imageNamed: "menuTower")
    private let bricksLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    private let rowsLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    private let buildRowButton = IconButton(image: "build")
    private let viewModeButton = IconButton(image: "back")
    private let player = Player()
    private let towerTop = SKSpriteNode(imageNamed: "towerTop")
    
    var delegate: PersonalTowerDelegate?
    
    var height: CGFloat {
        return bricksLabel.position.y + bricksLabel.frame.size.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        towerImage.zPosition = NodeZOrder.background + 0.01
        let towerWidth = CGFloat(TowerBricks.numberOfBricksInRow + 2) * brickWidth
        let towerHeight = CGFloat(TowerBricks.numberOfBricksInRow) * brickWidth
        towerImage.size = CGSize(width: towerWidth, height: towerHeight)
        towerImage.position = CGPoint(x: 0.0, y: towerImage.size.height / 2.0)
        
        towerTop.size = CGSize(
            width: towerImage.size.width * 0.8,
            height: towerImage.size.height * 0.25)
        towerTop.zPosition = NodeZOrder.background + 0.02
        
        player.physicsBody?.isDynamic = false
        
        buildRowButton.action = {
            if(TowerBricks.standard.canBuildRow) {
                TowerBricks.standard.buildRow()
                self.update()
            } else {
                if let main = self.scene as? Main {
                    self.buildRowButton.isHidden = true
                    main.disableUserInteraction()
                    // TODO freeze user input in main
                    InfoBox.showOnce(in: main,
                                     text: "Here you can build your own personal tower! Collect or buy five bricks to build a new row.", completion: {
                                        self.buildRowButton.isHidden = false
                                        main.isUserInteractionEnabled = true
                    })
                }
            }
        }
        
        viewModeButton.action = {
            self.update(viewMode: true)
            self.delegate?.towerViewModeStarted()
        }
        
        bricksLabel.zPosition = NodeZOrder.world
        bricksLabel.fontColor = SKColor.blue
        bricksLabel.fontSize = 16.0
        
        rowsLabel.zPosition = NodeZOrder.world
        rowsLabel.fontColor = SKColor.blue
        rowsLabel.fontSize = 18.0
        
        self.update()
    }
    
    func update(viewMode: Bool = false) {
        self.removeAllChildren()
        
        self.addChild(towerImage)
        
        var y: CGFloat = towerImage.size.height
        y += self.buildTower(at: y)
        
        player.position = CGPoint(x: 0.0, y: y + 2.0 + player.size.height / 2.0)
        self.addChild(player)
        
        if(!viewMode) {
            towerTop.position = player.position
            self.addChild(towerTop)
            
            buildRowButton.position = CGPoint(x: 0.0, y: player.position.y + player.size.height / 2.0 + 10.0 + buildRowButton.size.height / 2.0)
            self.addChild(buildRowButton)
            
            viewModeButton.position = buildRowButton.position
            viewModeButton.position.x += buildRowButton.size.width + 10.0
            self.addChild(viewModeButton)
            
            rowsLabel.position = CGPoint(x: 0.0, y: buildRowButton.position.y + buildRowButton.size.height / 2.0 + 10.0)
            self.addChild(rowsLabel)
            
            bricksLabel.position = CGPoint(x: 0.0, y: rowsLabel.position.y + rowsLabel.frame.size.height / 2.0 + 10.0)
            self.addChild(bricksLabel)

            y = player.position.y - player.size.height / 2.0
            self.buildBrickStore(at: y)
        }
    }
    
    private func buildTower(at startY: CGFloat) -> CGFloat {
        var y = startY
        
        let rows = TowerBricks.standard.rows
        rowsLabel.text = "Tower height: \(rows.count)"
        for row in rows {
            var x: CGFloat = -CGFloat(TowerBricks.numberOfBricksInRow) / 2.0 * brickWidth
            for brick in row {
                let brickNode = SKSpriteNode(imageNamed: brick.textureName)
                brickNode.zPosition = NodeZOrder.world + 0.02
                brickNode.size = brickSize
                brickNode.position = CGPoint(x: x + brickWidth / 2.0, y: y + brickHeight / 2.0)
                self.addChild(brickNode)
                x += brickWidth
            }
            
            let rowBackground = SKSpriteNode(
                color: SKColor(named: "towerBg") ?? SKColor.black,
                size: CGSize(width: CGFloat(row.count) * brickWidth, height: brickHeight))
            rowBackground.zPosition = NodeZOrder.world + 0.01
            rowBackground.position = CGPoint(x: 0.0, y: y + brickHeight / 2.0)
            self.addChild(rowBackground)
            
            y += brickHeight
        }
        
        return y - startY
    }
    
    private func buildBrickStore(at startY: CGFloat) {
        let bricks = TowerBricks.standard.bricks
        bricksLabel.text = bricks.count > 0 ? "Bricks left: \(bricks.count)" : ""
        
        let x = player.position.x - player.size.width / 2.0 - brickWidth / 2.0 - 35.0
        var y = startY
        
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
