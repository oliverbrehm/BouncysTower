//
//  GameViewController.swift
//  TowerJump iOS
//
//  Created by Oliver Brehm on 02.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class IOSGameViewController: GameViewController {
    
    public var lastX : CGFloat = 0.0;

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func touchDown(atPoint pos : CGPoint) {
        self.Game?.player.StartMoving()
        lastX = pos.x
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let dx = pos.x - lastX
        
        self.Game?.player.Move(x: dx)
        
        lastX = pos.x
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if(self.Game?.allowJump ?? false && (self.Game?.gameState == .Started || self.Game?.gameState == .Running)) {
            self.Game?.player.ReleaseMove()
        }
        
        if(self.Game?.gameState == .Started) {
            self.Game?.gameState = .Running
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self.view)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self.view)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.view)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.view)) }
    }
}
