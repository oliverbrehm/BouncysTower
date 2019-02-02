//
//  InfoBox.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class InfoBox : Button {
    
    let label = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    
    init() {
        super.init(caption: "", size: CGSize.zero, fontSize: 14.0, fontColor: SKColor.black, backgroundColor: SKColor.white, pressedColor: SKColor.white)
    
        self.label.fontSize = 14.0
        self.label.fontColor = SKColor.black
        self.addChild(self.label)
        
        self.setScale(0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func Show(text: String, completion: @escaping () -> Void) {
        self.Action = {
            self.run(SKAction.sequence([
                SKAction.scale(to: 0.0, duration: 0.3),
                SKAction.run {
                    completion()
                }
            ]))
        }
        
        self.label.text = text
        self.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
}
