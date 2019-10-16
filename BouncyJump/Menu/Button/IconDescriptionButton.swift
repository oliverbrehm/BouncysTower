//
//  IconDescriptionButton.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 20.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class IconDescriptionButton: SKSpriteNode {
    
    private let iconButton: IconButton
    
    var enabled: Bool {
        get {
            return iconButton.enabled
        }
        set {
            iconButton.enabled = newValue
        }
    }
    
    var action : (() -> Void)? {
        get {
            return iconButton.action
        }
        set {
            iconButton.action = newValue
        }
    }
    
    init(description: String, image: String) {

        iconButton = IconButton(image: image)

        super.init(texture: nil, color: SKColor.clear, size: CGSize.zero)
        
        self.zPosition = NodeZOrder.button
        
        let margin: CGFloat = 10.0
        
        let label = SKLabelNode(fontNamed: Font.fontName)
        self.addChild(iconButton)
        self.addChild(label)
        
        label.text = description
        label.fontSize = 22.0
        label.fontColor = SKColor.white
        
        let width = label.frame.size.width + margin + iconButton.size.width
        let height = max(label.frame.size.height, iconButton.size.height)
        self.size = CGSize(width: width, height: height)
        
        iconButton.position = CGPoint(x: -width / 2.0 + iconButton.size.width / 2.0, y: 0.0)
        label.position = CGPoint(x: width / 2.0 - label.frame.size.width / 2.0, y: -label.frame.size.height / 2.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        iconButton = IconButton(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
}
