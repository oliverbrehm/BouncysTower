//
//  File.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Background: SKNode {
    
    let height: CGFloat
    
    init(screenSize: CGSize, towerHeight: CGFloat) {
        let bg = SKSpriteNode(imageNamed: "menuBackground")
        self.height = screenSize.height * (bg.size.width / screenSize.width)
        
        super.init()
                
        bg.zPosition = NodeZOrder.background
        bg.size = CGSize(width: screenSize.width, height: height)
        bg.position = CGPoint(x: 0.0, y: height / 2)
        self.addChild(bg)

        setupStars(towerHeight: towerHeight, screenSize: screenSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.height = 0
        super.init(coder: aDecoder)
    }
    
    func setupStars(towerHeight: CGFloat, screenSize: CGSize) {
        let start = height - screenSize.height / 2

        guard towerHeight > start else { return }

        var y = start
        
        while y < towerHeight {
            let starNode = SKSpriteNode(imageNamed: "spark")
            let x = CGFloat.random(in: -screenSize.width / 2 ... screenSize.width / 2)
            starNode.position = CGPoint(x: x, y: y)
            let diameter = CGFloat.random(in: 3 ... 8)
            let color = SKColor.random()
            starNode.size = CGSize(width: diameter, height: diameter)
            starNode.color = color
            starNode.colorBlendFactor = CGFloat.random(in: 0 ... 0.2)
            addChild(starNode)
            
            y += 5
        }
    }
}

class Main: SKScene, ShopDelegate, PersonalTowerDelegate {
    func purchaseDone() {
        self.tower.update()
        self.menuOverlay.stopHighlightingResourceView()
    }
    
    private var scrollSpeed: CGFloat = 0.0
    private var scrollReleaseSpeed: CGFloat = 0.0
    private var touching = false
    private var releaseTime: TimeInterval = 0.0
    private let afterScrollTime: TimeInterval = 0.6
    
    var gameViewController: GameViewController?
    
    private var menuOverlay = OverlayMain()
    private var tower = PersonalTower()
    private var background: Background?
    private let stopViewModeButton = IconButton(image: "options")
    
    private let ambientLightsParticles = SKEmitterNode(fileNamed: "MenuLights")!
    private let ambientSkyParticles = SKEmitterNode(fileNamed: "MenuSky")!
    
    private var bottom: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        let w = self.frame.size.width
        let h = self.frame.size.height
        let size = CGSize(width: max(w, h), height: min(w, h))
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        
        self.addChild(self.menuOverlay)
        self.menuOverlay.setup(size: size, menu: self)
        self.menuOverlay.show()
        
        self.bottom = -size.height / 2.0
        
        self.addChild(tower)
        tower.position = CGPoint(x: -0.25 * size.width, y: bottom)
        
        stopViewModeButton.position = CGPoint(
            x: size.width / 2.0 - stopViewModeButton.size.width / 2.0 - Config.roundedDisplayMargin,
            y: size.height / 2.0 - stopViewModeButton.size.height / 2.0 - Config.roundedDisplayMargin)
        stopViewModeButton.isHidden = true
        self.addChild(stopViewModeButton)
        stopViewModeButton.action = self.towerViewModeStopped
        
        tower.delegate = self
        
        self.background = Background(screenSize: size, towerHeight: tower.height)
        background!.position = CGPoint(x: 0.0, y: bottom)
        self.addChild(background!)
        
        addChild(ambientLightsParticles)
        addChild(ambientSkyParticles)
        
        ambientLightsParticles.targetNode = background
        ambientSkyParticles.targetNode = background
        
        ambientLightsParticles.position = CGPoint.zero
        ambientSkyParticles.position = CGPoint(x: -size.width / 2, y: 0)
        
        ambientSkyParticles.particleBirthRate = 0
        
        if Config.standard.coins >= ResourceManager.costExtraLife {
            // show shop if player collected enough coins for an extra life
            if Config.standard.shouldShow(tutorial: .shop) {
                self.run(SKAction.wait(forDuration: 1.0)) {
                    InfoBox.show(
                        in: self,
                        text: Tutorial.shop.message,
                        imageName: Tutorial.shop.imageName,
                        imageHeight: Tutorial.shop.imageHeight,
                        completion: 
                    {
                        Config.standard.setTutorialShown(.shop)
                        self.menuOverlay.highlightResourceView()
                    })
                }
            }
        }
        
        Score.standard.unsetRecentRank() // clear recent rank (will not be highlighted in score list)
    }
    
    private func updateAmbientParticles(backgroundPosition: CGFloat) {
        let screenHeight = min(self.frame.size.width, self.frame.size.height)
        
        // if user scrolls up far enough the sky particles become visible and the lights disappear
        if backgroundPosition > 1.4 * screenHeight {
            ambientSkyParticles.particleBirthRate = 0.4
            ambientLightsParticles.particleBirthRate = 0
        } else {
            ambientSkyParticles.particleBirthRate = 0
            ambientLightsParticles.particleBirthRate = 1.0
        }
    }
    
    func disableUserInteraction() {
        menuOverlay.disableUserInteraction()
    }
    
    func enableUserInteraction() {
        menuOverlay.enableUserInteraction()
    }
    
    private func moveTower(dy: CGFloat) {
        if tower.height < size.height {
            return
        }
        
        tower.position.y += dy
        
        if tower.position.y > bottom {
            tower.position.y = bottom
            scrollSpeed = 0.0
        } else if tower.position.y + tower.height < size.height / 2.0 {
            tower.position.y = size.height / 2.0 - tower.height
            scrollSpeed = 0.0
        }

        let backgroundAdjustment = bottom + (tower.position.y - bottom) * 0.5
        background?.position.y = backgroundAdjustment
        
        updateAmbientParticles(backgroundPosition: -backgroundAdjustment)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let y2 = touches.first?.location(in: self).y
        let y1 = touches.first?.previousLocation(in: self).y
        if y1 != nil && y2 != nil && TowerBricks.standard.rows.count > 0 {
            let dy = CGFloat(y2! - y1!)
            self.moveTower(dy: dy)
            self.scrollSpeed = dy
            self.scrollReleaseSpeed = dy
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touching = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touching = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if touching {
            self.releaseTime = currentTime
        } else if abs(scrollSpeed) > 0.1 && TowerBricks.standard.rows.count > 0 {
            self.moveTower(dy: scrollSpeed)
            let dt = currentTime - releaseTime
            self.scrollSpeed = CGFloat(afterScrollTime - dt) * scrollReleaseSpeed
        }
    }
    
    func towerViewModeStarted() {
        self.menuOverlay.hide()
        self.tower.run(SKAction.moveTo(x: 0.0, duration: 0.5))
        self.stopViewModeButton.isHidden = false
    }
    
    func towerViewModeStopped() {
        self.menuOverlay.show()
        self.tower.run(SKAction.moveTo(x: -0.25 * size.width, duration: 0.5))
        self.tower.update()
        self.stopViewModeButton.isHidden = true
    }
}
