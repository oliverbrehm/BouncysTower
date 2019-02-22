//
//  InfoBox.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class InfoBox: Button {
    
    var lines: [SKLabelNode] = []
    var image: SKSpriteNode?
    
    init() {
        let color = SKColor(white: 1.0, alpha: 0.8)
        super.init(caption: "", size: CGSize.zero, fontSize: 14.0, fontColor: SKColor.black, backgroundColor: color, pressedColor: color)
        self.setScale(0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func clear() {
        for node in self.lines {
            node.removeFromParent()
        }
        self.lines.removeAll()
        self.image?.removeFromParent()
        self.image = nil
    }
    
    func addLine(text: String) {
        let label = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        label.text = text
        label.fontSize = 12.0
        label.fontColor = SKColor.black
        self.addChild(label)
        self.lines.append(label)
        
        self.updateLayout()
    }
    
    func setImage(name: String, height: CGFloat) {
        if(self.image != nil) {
            self.image?.removeFromParent()
        }
        
        let img = SKSpriteNode(imageNamed: name)
        self.image = img
        img.size = CGSize(width: height / img.size.height * img.size.width, height: height)
        
        self.addChild(img)
        
        self.updateLayout()
    }
    
    private func updateLayout() {
        if let game = self.scene as? Game {
            let margin: CGFloat = 10.0
            
            let lineHeight: CGFloat = self.lines.first != nil ? self.lines.first!.frame.size.height : 0.0
            let lineMargin: CGFloat = 6.0
            let imageHeight: CGFloat = self.image != nil ? self.image!.frame.height : 0.0
            let nElements = self.lines.count + (self.image != nil ? 1 : 0)
            
            let contentHeight = CGFloat(self.lines.count) * lineHeight + (self.image != nil ? imageHeight : 0.0) + CGFloat(nElements - 1) * lineMargin
            
            for (index, node) in self.lines.enumerated() {
                node.position.y = contentHeight / 2.0 - CGFloat(index) * (lineHeight + lineMargin) - lineHeight
            }
            
            if let img = self.image {
                img.position.y = -contentHeight / 2.0 + imageHeight / 2.0
            }
            
            let totalHeight = contentHeight + 2 * margin
            self.size = CGSize(width: game.world.width * 0.75, height: totalHeight)
            self.position = CGPoint(x: 0.0, y: game.world.height / 2.0 - margin - totalHeight / 2.0)
        }
    }
    
    func show(completion: @escaping () -> Void) {
        self.removeAllActions()
        
        self.action = {
            self.run(SKAction.sequence([
                SKAction.scale(to: 0.0, duration: 0.3),
                SKAction.run {
                    completion()
                }
            ]))
        }
        
        self.run(SKAction.scale(to: 1.0, duration: 0.3))
        self.run(SoundController.standard.getSoundAction(action: .message))
        print("playing sound")
        
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.9, duration: 0.5),
            SKAction.fadeAlpha(to: 0.7, duration: 0.5)
        ])))
    }
}
