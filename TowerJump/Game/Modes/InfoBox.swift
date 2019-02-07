//
//  InfoBox.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class InfoBox : Button {
    
    var lines: [SKLabelNode] = []
    
    init() {
        let color = SKColor(white: 1.0, alpha: 0.8)
        super.init(caption: "", size: CGSize.zero, fontSize: 14.0, fontColor: SKColor.black, backgroundColor: color, pressedColor: color)
        self.setScale(0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func Setup(size: CGSize) {
        self.size = size
        
        let label = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        label.fontSize = 16.0
        label.fontColor = SKColor.red
        label.text = "X"
        
        label.position = CGPoint(x: size.width / 2.0 - label.frame.width / 2.0 - 5.0, y: size.height / 2.0 - label.frame.height - 5.0)
        self.addChild(label)
    }
    
    public func Clear() {
        for node in self.lines {
            node.removeFromParent()
        }
        self.lines.removeAll()
    }
    
    public func AddLine(text: String) {
        let label = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        label.text = text
        label.fontSize = 12.0
        label.fontColor = SKColor.black
        self.addChild(label)
        self.lines.append(label)
        
        // layout lines y position
        let lineHeight = label.frame.size.height
        let lineMargin: CGFloat = 6.0
        let totalHeight = CGFloat(self.lines.count) * lineHeight + CGFloat(self.lines.count - 1) * lineMargin
        for (index, node) in self.lines.enumerated() {
            node.position.y = totalHeight / 2.0 - CGFloat(index) * (lineHeight + lineMargin) - lineHeight
        }
    }
    
    public func Show(completion: @escaping () -> Void) {
        self.Action = {
            self.run(SKAction.sequence([
                SKAction.scale(to: 0.0, duration: 0.3),
                SKAction.run {
                    completion()
                }
            ]))
        }
        
        self.run(SKAction.scale(to: 1.0, duration: 0.3))
        self.run(SoundController.Default.GetSoundAction(action: .Message))
    }
}
