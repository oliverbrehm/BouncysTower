//
//  Button.swift
//  TowerJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Button: SKSpriteNode {
    var action : (() -> Void)?
    
    private var label: SKLabelNode
    private var backgroundColor: SKColor = SKColor.darkGray
    private var pressedColor: SKColor = SKColor.lightGray
    
    var focussed: Bool = false {
        didSet {
            if(focussed) {
                self.color = self.pressedColor
            } else {
                self.color = self.backgroundColor
            }
        }
    }
    
    static func focusNextInScene(_ scene: SKScene) {
        // TODO
    }
    
    convenience init(caption: String) {
        self.init(caption: caption,
                  size: CGSize(width: 200.0, height: 70.0),
                  fontSize: 30.0, fontColor: SKColor.init(named: "overlay")!,
                  backgroundColor: SKColor.lightGray,
                  pressedColor: SKColor.white)
    }
    
    init(caption: String, size: CGSize, fontSize: CGFloat, fontColor: SKColor, backgroundColor: SKColor, pressedColor: SKColor) {
        self.backgroundColor = backgroundColor
        self.pressedColor = pressedColor
        
        self.label = SKLabelNode(text: caption)
        self.label.fontColor = fontColor
        self.label.position = CGPoint(x: 0.0, y: -fontSize / 2.0)
        self.label.fontSize = fontSize
        self.label.fontName = "AmericanTypewriter-Bold"
        self.label.zPosition = NodeZOrder.label
        
        super.init(texture: nil, color: backgroundColor, size: size)
        self.name = "button"

        self.zPosition = NodeZOrder.button
        
        self.isUserInteractionEnabled = true
        
        self.addChild(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.label = SKLabelNode(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
    
    func touchUp(point: CGPoint) {
        if(self.focussed) {
            self.focussed = false
            
            if(self.frame.contains(point) && self.action != nil) {
                self.action?()
            }
        }
    }
    
    func touchDown(point: CGPoint) {
        self.focussed = true
        self.run(SoundController.standard.getSoundAction(action: .button))
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
    
    func setText(text: String) {
        self.label.text = text
    }
}
