//
//  PrivateTower.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 02.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

protocol PersonalTowerDelegate: class {
    func towerViewModeStarted()
}

class TowerBrick: SKSpriteNode {
    private let brick: Brick
    
    static let brickWidth: CGFloat = 42.0
    static let brickHeight: CGFloat = 28.0
    
    init(brick: Brick, size: CGSize, inStore: Bool) {
        self.brick = brick
        
        super.init(texture: SKTexture.init(imageNamed: brick.textureName), color: UIColor.clear, size: size)
        
        self.zPosition = NodeZOrder.overlay + 0.02
        
        self.setInStore(inStore)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.brick = .standard
        super.init(coder: aDecoder)
    }
    
    func setInStore(_ inStore: Bool) {
        self.alpha = inStore ? 0.7 : 1.0
        self.isUserInteractionEnabled = inStore ? false : true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.zPosition = NodeZOrder.overlay + 0.03
        self.run(AudioController.standard.getSoundAction(action: .brick(type: self.brick)))
        self.run(self.brick.selectAction) {
            self.zPosition = NodeZOrder.overlay + 0.02
        }
    }
}

class BrickStore: SKNode {
    private var bricks: [TowerBrick] = []

    init(bricks: [Brick]) {
        super.init()
        
        var y: CGFloat = 0.0
        
        for brick in bricks {
            let brickNode = TowerBrick(brick: brick, size: CGSize(width: TowerBrick.brickWidth, height: TowerBrick.brickHeight), inStore: true)
            self.bricks.append(brickNode)
            self.addChild(brickNode)
            brickNode.position = CGPoint(x: 0.0, y: y + TowerBrick.brickWidth / 2.0)
            
            y += TowerBrick.brickHeight
        }
    }
    
    var numberOfBricks: Int {
        return bricks.count
    }
    
    func takeBrick() -> TowerBrick {
        let brick = bricks.removeFirst()
        brick.setInStore(false)
        
        brick.run(SKAction.fadeOut(withDuration: 0.3)) {
            brick.removeFromParent()
            for b in self.bricks {
                b.run(SKAction.moveBy(x: 0.0, y: -TowerBrick.brickHeight, duration: 0.3))
            }
        }
        
        return brick
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class PersonalTower: SKNode {
    
    private var brickSize: CGSize {
        return CGSize(width: TowerBrick.brickWidth, height: TowerBrick.brickHeight)
    }
    
    private let towerImage = SKSpriteNode(imageNamed: "menuTower")
    private let bricksLabel = SKLabelNode(fontNamed: Constants.fontName)
    private let rowsLabel = SKLabelNode(fontNamed: Constants.fontName)
    private let buildRowButton = IconButton(image: "build")
    private let viewModeButton = IconButton(image: "back")
    private let player = Player(jumpOnTouch: true)
    private let towerTop = SKSpriteNode(imageNamed: "towerTop")
    private let background = SKSpriteNode(color: SKColor(named: "towerBg") ?? SKColor.black, size: CGSize.zero)
    private var brickStore: BrickStore?
    private var buildParticles: [SKEmitterNode] = []
    
    weak var delegate: PersonalTowerDelegate?
    
    var height: CGFloat {
        return bricksLabel.position.y + bricksLabel.frame.size.height + 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        towerImage.zPosition = NodeZOrder.background + 0.01
        let towerWidth = CGFloat(TowerBricks.numberOfBricksInRow + 2) * TowerBrick.brickWidth
        let towerHeight = CGFloat(TowerBricks.numberOfBricksInRow) * TowerBrick.brickWidth
        towerImage.size = CGSize(width: towerWidth, height: towerHeight)
        towerImage.position = CGPoint(x: 0.0, y: towerImage.size.height / 2.0)
        towerImage.physicsBody = SKPhysicsBody(rectangleOf: towerImage.size)
        towerImage.physicsBody?.isDynamic = false
        
        towerTop.size = CGSize(
            width: towerImage.size.width * 0.8,
            height: towerImage.size.height * 0.25)
        towerTop.zPosition = NodeZOrder.background + 0.02
        
        buildRowButton.action = {
            if !InAppPurchaseManager.shared.premiumPurchased && Score.standard.towerHeight >= 4 {
                if let main = self.scene as? Main {
                    InfoBox.show(in: main, text: "You cannot build your tower any higher in the free version. " +
                        "Please consider buying premium to build as far up as you like!", onShow: nil)
                    {
                        if let vc = self.scene?.view?.window?.rootViewController as? GameViewController {
                            AdvertisingController.shared.present(in: vc)
                        }
                    }
                }
            } else if(TowerBricks.standard.canBuildRow) {
                self.buildRow()
            } else {
                if let main = self.scene as? Main {
                    InfoBox.show(in: main,
                                 text: "Here you can build your own personal tower! Collect or buy five bricks to build a new row.",
                                 onShow:
                        {
                            self.buildRowButton.isHidden = true
                            main.disableUserInteraction()
                            // TODO freeze user input in main
                         },
                         completion: {
                            self.buildRowButton.isHidden = false
                            main.isUserInteractionEnabled = true
                         }
                    )
                }
            }
        }
        
        viewModeButton.action = {
            self.update(viewMode: true)
            self.delegate?.towerViewModeStarted()
        }
        
        bricksLabel.zPosition = NodeZOrder.world
        bricksLabel.fontColor = Constants.colors.menuForeground
        bricksLabel.fontSize = 16.0
        
        rowsLabel.zPosition = NodeZOrder.world
        rowsLabel.fontColor = Constants.colors.menuForeground
        rowsLabel.fontSize = 18.0
        
        self.update()
    }
    
    private func buildRow() {
        buildRowButton.isHidden = true

        player.jump()
        
        TowerBricks.standard.buildRow()
        
        setupNodes()
        
        let nRows = TowerBricks.standard.rows.count
        
        buildParticles.removeAll()
        for n in 0 ..< 5 {
            let emitter = SKEmitterNode(fileNamed: "JumpParticle")!
            emitter.zPosition = NodeZOrder.world + 0.04
            self.addChild(emitter)
            emitter.position = CGPoint(x: -background.size.width / 2.0 + TowerBrick.brickWidth / 2.0 + CGFloat(n) * TowerBrick.brickWidth,
                                       y: self.background.top - TowerBrick.brickHeight / 2.0)
            buildParticles.append(emitter)
        }
        
        var newBrickX = 0
        
        let buildAction = SKAction.repeat(SKAction.sequence([
            SKAction.wait(forDuration: 0.4), // wait for brick to be removed from store
            SKAction.run {
                self.addBrickFromStore(posX: newBrickX)
                newBrickX += 1
            }
        ]), count: 5)
        
        self.run(SKAction.sequence([
            buildAction,
            SKAction.wait(forDuration: 0.5),
            AudioController.standard.getSoundAction(action: .cheer)
        ])) {
            self.buildRowButton.isHidden = false
            self.rowsLabel.text = "Tower height: \(nRows)"
            if let main = self.scene, nRows >= 2 && Config.standard.shouldShow(tutorial: .towerMultiplicator) {
                InfoBox.show(in: main, text: Tutorial.towerMultiplicator.message)
                Config.standard.setTutorialShown(.towerMultiplicator)
            }
        }
    }
    
    private func setupNodes() {
        background.size = CGSize(
            width: 5 * TowerBrick.brickWidth,
            height: CGFloat(TowerBricks.standard.rows.count) * TowerBrick.brickHeight)
        background.position = CGPoint(x: 0.0, y: towerImage.top + background.size.height / 2.0)
        background.physicsBody = SKPhysicsBody.init(rectangleOf: background.size)
        background.physicsBody?.isDynamic = false
        
        brickStore?.position.y += TowerBrick.brickHeight
        bricksLabel.position.y += TowerBrick.brickHeight
        viewModeButton.position.y += TowerBrick.brickHeight
        buildRowButton.position.y += TowerBrick.brickHeight
        towerTop.position.y += TowerBrick.brickHeight
        rowsLabel.position.y += TowerBrick.brickHeight
    }
    
    private func addBrickFromStore(posX: Int) {
        if let store = brickStore {
            let brick = store.takeBrick()
            self.run(SKAction.wait(forDuration: 0.4)) {
                self.bricksLabel.text = "Bricks left: \(store.numberOfBricks)"
                if(store.numberOfBricks == 0) {
                    self.bricksLabel.isHidden = true
                }
                self.addChild(brick)

                brick.position = CGPoint(x: -self.background.size.width / 2.0 + TowerBrick.brickWidth / 2.0 + CGFloat(posX) * TowerBrick.brickWidth,
                                         y: self.background.top - TowerBrick.brickHeight / 2.0)
                brick.run(SKAction.fadeIn(withDuration: 0.3)) {
                    let emitter = self.buildParticles[posX]
                    emitter.removeFromParent()
                }
            }
        }
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
            
            buildRowButton.position = CGPoint(x: 0.0, y: player.position.y + player.size.height / 2.0 + 20.0 + buildRowButton.size.height / 2.0)
            self.addChild(buildRowButton)
            
            viewModeButton.position = buildRowButton.position
            viewModeButton.position.x += buildRowButton.size.width + 10.0
            self.addChild(viewModeButton)
            
            rowsLabel.position = CGPoint(x: 0.0, y: buildRowButton.position.y + buildRowButton.size.height / 2.0 + 20.0)
            self.addChild(rowsLabel)
            
            bricksLabel.position = CGPoint(x: 0.0, y: rowsLabel.position.y + rowsLabel.frame.size.height / 2.0 + 15.0)
            self.addChild(bricksLabel)

            y = player.position.y - player.size.height / 2.0
            self.buildBrickStore(at: y)
        }
    }
    
    private func buildTower(at startY: CGFloat) -> CGFloat {
        var y = startY
        
        let rows = TowerBricks.standard.rows
        rowsLabel.text = "Tower height: \(rows.count)"
        
        background.size = CGSize(width: 5 * TowerBrick.brickWidth, height: CGFloat(rows.count) * TowerBrick.brickHeight)
        background.zPosition = NodeZOrder.world + 0.01
        background.position = CGPoint(x: 0.0, y: y + background.size.height / 2.0)
        background.physicsBody = SKPhysicsBody.init(rectangleOf: background.size)
        background.physicsBody?.isDynamic = false
        self.addChild(background)
        
        for row in rows {
            var x: CGFloat = -CGFloat(TowerBricks.numberOfBricksInRow) / 2.0 * TowerBrick.brickWidth
            for brick in row {
                let brickNode = TowerBrick(brick: brick, size: brickSize, inStore: false)
                brickNode.position = CGPoint(x: x + TowerBrick.brickWidth / 2.0, y: y + TowerBrick.brickHeight / 2.0)
                self.addChild(brickNode)
                x += TowerBrick.brickWidth
            }

            y += TowerBrick.brickHeight
        }
        
        return y - startY
    }
    
    private func buildBrickStore(at startY: CGFloat) {
        let bricks = TowerBricks.standard.bricks
        bricksLabel.text = bricks.count > 0 ? "Bricks left: \(bricks.count)" : ""
        
        let x = player.position.x - player.size.width / 2.0 - TowerBrick.brickWidth / 2.0 - 35.0
        
        self.brickStore = BrickStore(bricks: bricks)
        self.addChild(brickStore!)
        brickStore?.position = CGPoint(x: x, y: startY)
    }
}
