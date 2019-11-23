//
//  IconDescriptionButton.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 20.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class IconDescriptionButton: SKSpriteNode {
    
    private let iconButton: IconButton
    private let labelButton: LabelButton
    
    var enabled: Bool {
        get {
            return iconButton.enabled
        }
        set {
            iconButton.enabled = newValue
            labelButton.enabled = newValue
        }
    }
    
    var action : (() -> Void)? {
        get {
            return iconButton.action
        }
        set {
            iconButton.action = newValue
            labelButton.action = newValue
        }
    }
    
    init(description: String, image: String) {

        iconButton = IconButton(image: image)
        labelButton = LabelButton(withText: description)

        super.init(texture: nil, color: SKColor.clear, size: CGSize.zero)
        
        self.addChild(iconButton)
        self.addChild(labelButton)
        
        self.zPosition = NodeZOrder.button
        
        let margin: CGFloat = 10.0
        
        let width = iconButton.size.width + margin + labelButton.size.width
        
        iconButton.position = CGPoint(x: -width / 2.0 + iconButton.size.width / 2.0, y: 0.0)
        labelButton.position = CGPoint(x: width / 2.0 - labelButton.frame.size.width / 2.0, y: -labelButton.label.frame.size.height / 2.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        iconButton = IconButton(coder: aDecoder)!
        labelButton = LabelButton(withText: "")
        super.init(coder: aDecoder)
    }
}
