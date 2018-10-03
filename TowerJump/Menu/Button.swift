//
//  Button.swift
//  TowerJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Button : SKSpriteNode
{
    public var Action : (() -> Void)?
    
    private var label : SKLabelNode
    private var backgroundColor : SKColor = SKColor.darkGray
    private var pressedColor : SKColor = SKColor.lightGray
    
    private var pressed : Bool = false
    public var Pressed : Bool {
        get {
            return pressed
        } set {
            pressed = newValue
            if(newValue) {
                self.color = self.pressedColor
            } else {
                self.color = self.backgroundColor
            }
        }
    }
    
    public convenience init(caption: String)
    {
        self.init(caption: caption, size: CGSize(width: 200.0, height: 70.0), fontSize: 30.0, fontColor: SKColor.red, backgroundColor: SKColor.darkGray, pressedColor: SKColor.lightGray)
    }
    
    public init(caption: String, size: CGSize, fontSize: CGFloat, fontColor: SKColor, backgroundColor: SKColor, pressedColor: SKColor)
    {
        self.backgroundColor = backgroundColor
        self.pressedColor = pressedColor
        
        self.label = SKLabelNode(text: caption)
        self.label.fontColor = fontColor
        self.label.position = CGPoint.zero
        self.label.fontSize = fontSize
        
        super.init(texture: nil, color: backgroundColor, size: size)
        
        self.isUserInteractionEnabled = true
        
        self.addChild(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.label = SKLabelNode(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
    
    public func TouchUp(point : CGPoint)
    {
        if(self.pressed) {
            self.Pressed = false
            
            if(self.frame.contains(point) && self.Action != nil) {
                self.Action?()
            }
        }
    }
    
    public func TouchDown(point : CGPoint)
    {
        self.Pressed = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.TouchDown(point: t.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if let parent = self.parent {
                self.TouchUp(point: t.location(in: parent))
            }
        }
    }
    
    public func SetText(text: String) {
        self.label.text = text
    }
}
