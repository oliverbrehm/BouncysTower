//
//  File.swift
//  TowerJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Background: SKNode {
    init(screenSize: CGSize) {
        super.init()
        
        let bg1 = SKSpriteNode(imageNamed: "bgmenu1")
        bg1.zPosition = NodeZOrder.background
        bg1.size = screenSize
        bg1.position = CGPoint(x: 0.0, y: 0.5 * screenSize.height)
        self.addChild(bg1)
        
        let bg2 = SKSpriteNode(imageNamed: "bgmenu2")
        bg2.zPosition = NodeZOrder.background
        bg2.size = screenSize
        bg2.position = CGPoint(x: 0.0, y: 1.5 * screenSize.height)
        self.addChild(bg2)
        
        let bg3 = SKSpriteNode(imageNamed: "bgmenu3")
        bg3.zPosition = NodeZOrder.background
        bg3.size = screenSize
        bg3.position = CGPoint(x: 0.0, y: 2.5 * screenSize.height)
        self.addChild(bg3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class Main: SKScene, ShopDelegate {
    func purchaseDone() {
        self.tower.update()
    }
    
    var gameViewController: GameViewController?
    
    private var menuOverlay = OverlayMain()
    private var tower = PersonalTower()
    private var background: Background?
    
    private var bottom: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        let w = self.frame.size.width
        let h = self.frame.size.height
        let size = CGSize(width: max(w, h), height: min(w, h))
        
        self.addChild(self.menuOverlay)
        self.menuOverlay.setup(size: size, menu: self)
        self.menuOverlay.show()
        
        self.background = Background(screenSize: size)
        self.addChild(background!)
        
        self.bottom = -size.height / 2.0
        
        self.addChild(tower)
        tower.position = CGPoint(x: -0.25 * size.width, y: bottom + 10.0)
        background!.position = CGPoint(x: 0.0, y: bottom)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let y2 = touches.first?.location(in: self).y
        let y1 = touches.first?.previousLocation(in: self).y
        if(y1 != nil && y2 != nil) {
            let dy = CGFloat(y2! - y1!)
            self.tower.position.y = min(self.bottom + 10.0, self.tower.position.y + dy)
            self.background?.position.y = min(self.bottom, self.background!.position.y + 0.2 * dy)
        }
    }
}
