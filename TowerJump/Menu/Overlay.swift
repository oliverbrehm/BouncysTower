//
//  Overlay.swift
//  TowerJump
//
//  Created by Oliver Brehm on 23.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Overlay : SKSpriteNode
{
    private var positionHidden = CGPoint.zero
    private var positionShown = CGPoint.zero
    
    init() {
        super.init(texture: SKTexture.init(imageNamed: "overlayBg"), color: SKColor.white, size: CGSize.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func Setup(scene: SKScene) {
        self.isHidden = true
        
        self.zPosition = NodeZOrder.Overlay
        
        let width: CGFloat = 0.7
        
        self.positionHidden = CGPoint(x: (0.5 + width / 2.0) * scene.frame.size.width, y: 0.0)
        self.positionShown = CGPoint(x: (0.5 - width / 2.0) * scene.frame.size.width, y: 0.0)
        self.position = self.positionHidden
        self.size = CGSize(width: width * scene.frame.size.width, height: scene.frame.size.height)
    }
    
    func Show()
    {
        self.isHidden = false
        self.run(SKAction.move(to: self.positionShown, duration: 0.25));
    }
    
    func Hide()
    {
        self.run(SKAction.sequence([
            SKAction.move(to: self.positionHidden, duration: 0.25),
            SKAction.run {
                self.isHidden = true
            }
            ]));
    }
}

