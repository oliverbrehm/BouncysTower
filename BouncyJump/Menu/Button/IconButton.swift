//
//  IconButton.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 01.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class IconButton: Button {
    private let backgroundImage = SKSpriteNode(imageNamed: "buttonbg")
    private let buttonImage: SKSpriteNode
    
    private var normalColor: SKColor?
    private var pressedColor: SKColor?
    
    override var focussed: Bool {
        didSet {
            if(focussed) {
                self.buttonImage.color = self.pressedColor ?? SKColor.clear
            } else {
                self.buttonImage.color = self.normalColor ?? SKColor.clear
            }
        }
    }
        
    init(image: String,
         backgroundColor: SKColor = Colors.menuForeground,
         color: SKColor = Colors.overlay,
         pressedColor: SKColor = Colors.cellBg) {
        let standardSize = CGSize(width: 50.0, height: 50.0)
        
        self.normalColor = color
        self.pressedColor = pressedColor
        
        self.buttonImage = SKSpriteNode(imageNamed: image)
        self.buttonImage.size = CGSize(width: standardSize.width * 0.35, height: standardSize.height * 0.35)
        self.buttonImage.color = color
        self.buttonImage.colorBlendFactor = 1.0
        self.buttonImage.zPosition = NodeZOrder.button + 0.01
        
        super.init(size: standardSize)
        
        self.backgroundImage.size = standardSize
        self.addChild(backgroundImage)
        backgroundImage.color = backgroundColor
        backgroundImage.colorBlendFactor = 1.0
        backgroundImage.zPosition = NodeZOrder.button
        
        self.addChild(self.buttonImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.buttonImage = SKSpriteNode(texture: nil, color: SKColor.clear, size: CGSize.zero)
        super.init(coder: aDecoder)
    }
    
    override func touchDown(point: CGPoint) {
        super.touchDown(point: point)
        
        if enabled {
            let rotate = SKAction.rotate(byAngle: -1.5, duration: 0.15)
            rotate.timingMode = .easeInEaseOut
            self.backgroundImage.run(rotate)
        }
    }
    
    override func touchUp(point: CGPoint) {
        super.touchUp(point: point)
        
        if enabled {
            let rotate = SKAction.rotate(byAngle: 1.5, duration: 0.15)
            rotate.timingMode = .easeInEaseOut
            self.backgroundImage.run(rotate)
        }
    }
}
