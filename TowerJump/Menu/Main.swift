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
        self.addChild(self.menuOverlay)
        self.menuOverlay.Setup(menu: self)
        self.menuOverlay.Show()
        
        let background = SKSpriteNode(imageNamed: "bg")
        background.size = self.frame.size
        background.color = SKColor.init(named: "bgLevel01")!
        background.colorBlendFactor = 1.0
        self.addChild(background)
        
        let towerImage = SKSpriteNode(imageNamed: "menuTower")
        towerImage.size = CGSize(width: self.frame.size.width / 2.0, height: self.frame.size.height)
        towerImage.position = CGPoint(x: -0.25 * self.frame.size.width, y: 0.0)
        self.addChild(towerImage)
    }
}
