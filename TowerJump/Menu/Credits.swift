//
//  Credits.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Credits : SKScene
{
    public var GameViewController : GameViewController?
    
    private var buttons : [Button] = []
    
    override func didMove(to view: SKView) {
        let infoLabel = SKLabelNode(text: "Made by Oliver Brehm")
        infoLabel.fontColor = SKColor.green
        infoLabel.fontSize = 28.0
        infoLabel.position = CGPoint(x: 0.0, y: 50.0)
        self.addChild(infoLabel)
        
        let backButton = Button(caption: "Back")
        backButton.position = CGPoint(x: 0.0, y: -50.0)
        backButton.Action = {
            self.GameViewController?.ShowMainMenu()
        }
        
        self.addChild(backButton)
        buttons.append(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            for button in self.buttons {
                button.TouchDown(point: t.location(in: self))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            for button in self.buttons {
                button.TouchUp(point: t.location(in: self))
            }
        }
    }
}
