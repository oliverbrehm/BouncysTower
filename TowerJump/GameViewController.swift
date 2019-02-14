//
//  GameViewController.swift
//  TowerJump
//
//  Created by Oliver Brehm on 12.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    public var Game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            AdvertisingController.Default.Setup(view: view)
        }
        
        ShowMainMenu()
    }

    public func ShowGame()
    {
        if !Config.Default.TutorialShown {
            self.ShowTutorial()
            return
        }
        
        if let scene = SKScene(fileNamed: "MainGame") as? MainGame {
            scene.scaleMode = .resizeFill
            scene.GameViewController = self
            
            self.Game = scene
            
            if let view = self.view as! SKView? {
                view.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 0.5))
            }
        }
    }

    public func ShowTutorial() {
        if let scene = SKScene(fileNamed: "Tutorial") as? Tutorial {
            scene.scaleMode = .resizeFill
            scene.GameViewController = self
            
            self.Game = scene
            
            if let view = self.view as! SKView? {
                view.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 0.5))
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
}
