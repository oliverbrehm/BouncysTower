//
//  File.swift
//  TowerJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Main : SKScene
{
    public var GameViewController : GameViewController?
    
    private var menuOverlay = OverlayMain()
    
    override func didMove(to view: SKView) {
        let w = self.frame.size.width
        let h = self.frame.size.height
        let size = CGSize(width: max(w, h), height: min(w, h))
        
        self.addChild(self.menuOverlay)
        self.menuOverlay.Setup(size: size, menu: self)
        self.menuOverlay.Show()
        
        let background = SKSpriteNode(imageNamed: "bg")
        background.zPosition = NodeZOrder.Background
        background.size = size
        background.color = SKColor.init(named: "bgLevel01")!
        background.colorBlendFactor = 1.0
        self.addChild(background)
        
        let towerImage = SKSpriteNode(imageNamed: "menuTower")
        towerImage.zPosition = NodeZOrder.Background + 0.01
        towerImage.size = CGSize(width: size.width / 2.0, height: size.height)
        towerImage.position = CGPoint(x: -0.25 * size.width, y: 0.0)
        self.addChild(towerImage)
    }
}
