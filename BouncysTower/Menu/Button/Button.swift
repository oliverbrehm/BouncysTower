//
//  Button.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Button: SKSpriteNode {
    var action: (() -> Void)?
    
    var focussed: Bool = false
    
    static func focusNextInScene(_ scene: SKScene) {
        // TODO: for OSX, TVOS
    }
    
    var enabled = true
    
    init(size: CGSize, color: SKColor = SKColor.clear) {
        super.init(texture: nil, color: color, size: size)
        self.name = "button"
        self.zPosition = NodeZOrder.button
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func touchUp(point: CGPoint) {
        guard enabled else { return }
        
        if self.focussed {
            self.focussed = false
            
            if self.frame.contains(point), self.action != nil, enabled {
                self.action?()
            }
        }
    }
    
    func touchDown(point: CGPoint) {
        guard enabled else { return }
        
        self.focussed = true
        self.run(SoundAction.button.action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(point: t.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if let parent = self.parent {
                self.touchUp(point: t.location(in: parent))
            }
        }
    }
}
