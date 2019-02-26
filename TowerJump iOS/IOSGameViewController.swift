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
    
    var lastX: CGFloat = 0.0

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
    
    func touchDown(atPoint pos: CGPoint) {
        self.movePlayer(pos: pos)
        
        lastX = pos.x
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        /*let dx = pos.x - lastX
        
        self.game?.player.move(x: dx)
        
        lastX = pos.x*/
        
        self.movePlayer(pos: pos)
    }
    
    private func movePlayer(pos: CGPoint) {
        if let g = self.game {
            if(g.state.runningState == .running && g.state.allowJump) {
                if pos.x < self.view.frame.size.width / 2.0 {
                    g.player.startMoving(directionLeft: true)
                } else {
                    g.player.startMoving(directionLeft: false)
                }
            }
        }
    }
    
    func touchUp(atPoint pos: CGPoint) {
        /*if(self.game?.state.allowJump ?? false && (self.game?.state.runningState == .started || self.game?.state.runningState == .running)) {
            self.game?.player.releaseMove()
        }*/
        
        if let g = self.game {
            g.player.stopMoving()
        }
        
        if(self.game?.state.runningState == .started) {
            self.game?.state.runningState = .running
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
