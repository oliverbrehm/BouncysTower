//
//  InfoBox.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 02.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class InfoBox: Button {
    
    private let label = SKLabelNode(fontNamed: Constants.fontName)
    private var image: SKSpriteNode?
    
    private let minHeight: CGFloat
    
    private var onShow: (() -> Void)?
    
    private static var messageQueue: [InfoBox] = []
    private static var messageQueueBusy = false
    
    init(width: CGFloat, minHeight: CGFloat) {
        self.minHeight = minHeight
        super.init(size: CGSize(width: width, height: minHeight), color: SKColor.white)
        
        self.zPosition = NodeZOrder.info
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        //self.setScale(0.0) // TODO somehow background is missing and text too long
        self.isHidden = true
        
        label.fontSize = 12.0
        label.fontColor = SKColor.black
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = size.width * 0.9
        label.lineBreakMode = .byWordWrapping
        label.horizontalAlignmentMode = .center
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.minHeight = 0.0
        super.init(coder: aDecoder)
    }
    
    static func show(in scene: SKScene,
                     text: String,
                     imageName: String? = nil, imageHeight: CGFloat? = nil,
                     onShow: (() -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        let width = scene.size.width * 0.8
        let height = scene.size.height * 0.3
        let infoBox = InfoBox(width: width, minHeight: height)
        infoBox.setText(text: text)
        if let img = imageName, let h = imageHeight {
            infoBox.setImage(name: img, height: h)
        }
        
        if let c = scene.camera {
            // at to camera if present
            c.addChild(infoBox)
        } else {
            // at to scene directly
            scene.addChild(infoBox)
        }
        
        infoBox.position = CGPoint(x: 0.0, y: scene.size.height / 2.0 - 20.0)
        
        infoBox.onShow = onShow
        
        infoBox.action = {
            infoBox.run(SKAction.sequence([
                SKAction.scale(to: 0.0, duration: 0.3),
                SKAction.run {
                    if infoBox.parent != nil {
                        infoBox.removeFromParent()
                    }
                    completion?()
                    messageQueueBusy = false
                    showNextInQueue()
                }
            ]))
        }
        
        messageQueue.append(infoBox)
        showNextInQueue()
    }
    
    private static func showNextInQueue() {
        if(!messageQueueBusy && !self.messageQueue.isEmpty) {
            let infoBox = messageQueue.removeFirst()
            infoBox.onShow?()
            infoBox.show()
            
            messageQueueBusy = true
        }
    }
    
    func clear() {
        self.label.text = ""
        self.image?.removeFromParent()
        self.image = nil
    }
    
    func setText(text: String) {
        label.text = text
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
        let margin: CGFloat = 10.0
        var contentHeight = label.frame.size.height
        if let img = image {
            contentHeight += margin + img.size.height
        }
        
        self.size.height = max(contentHeight + 2 * margin, self.minHeight)
        
        label.position = CGPoint(x: 0.0, y: -self.size.height / 2.0 + contentHeight / 2.0 - label.frame.size.height)
        image?.position = CGPoint(x: 0.0, y: label.position.y - margin - image!.size.height / 2.0)
        
    }
    
    private func show() {
        self.removeAllActions()

        self.run(SKAction.scale(to: 1.0, duration: 0.3))
        self.run(SoundController.standard.getSoundAction(action: .message))
        self.isHidden = false
        
        self.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.95, duration: 0.5),
            SKAction.fadeAlpha(to: 0.85, duration: 0.5)
        ])))
    }
}
