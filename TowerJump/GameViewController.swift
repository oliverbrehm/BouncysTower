//
//  GameViewController.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        ShowMainMenu()
    }
    
    public func ShowGame()
    {
        if let scene = SKScene(fileNamed: "Game") as? Game {
            scene.scaleMode = .resizeFill
            scene.GameViewController = self
            
            if let view = self.view as! SKView? {
                view.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 0.5))
            }
        }
    }
    
    public func ShowMainMenu()
    {
        if let view = self.view as! SKView? {
            
            var transitionDirection = SKTransitionDirection.right
            if(view.scene is Settings) {
                transitionDirection = SKTransitionDirection.left
            }
            
            if let scene = SKScene(fileNamed: "Main") as? Main {
                scene.scaleMode = .resizeFill
                scene.GameViewController = self
                view.presentScene(scene, transition: SKTransition.push(with: transitionDirection, duration: 0.5))
            }
        }
    }
    
    public func ShowCredits()
    {
        if let scene = SKScene(fileNamed: "Settings") as? Settings {
            scene.scaleMode = .resizeFill
            scene.GameViewController = self
            
            if let view = self.view as! SKView? {
                view.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 0.5))
            }
        }
    }

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
}
