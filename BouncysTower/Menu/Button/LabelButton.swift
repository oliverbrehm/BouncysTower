//
//  LabelButton.swift
//  BouncysTower iOS
//
//  Created by Oliver Brehm on 23.11.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class LabelButton: Button {
    
    let label = SKLabelNode(fontNamed: Font.fontName)

    init(withText text: String) {
        label.text = text
        label.fontSize = 22.0
        label.fontColor = SKColor.white
                
        super.init(size: CGSize(width: label.frame.width, height: IconButton.diameter))
        
        addChild(label)
    }
    
    override var focussed: Bool {
        didSet {
            label.fontColor = focussed ? SKColor.yellow : SKColor.white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
