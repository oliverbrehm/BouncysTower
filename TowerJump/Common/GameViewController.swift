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
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            AdvertisingController.Default.setup(view: view)
        }
        
        showMainMenu()
    }

    func showGame() {
        if !Config.standard.tutorialShown {
            self.showTutorial()
            return
        }
        
        if let scene = SKScene(fileNamed: "MainGame") as? MainGame {
            scene.scaleMode = .resizeFill
            scene.gameViewController = self
            
            self.game = scene
            
            if let view = self.view as? SKView {
                view.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 0.5))
            }
        }
    }
    
    func showShop() {
        /*
        if let scene = SKScene(fileNamed: "Shop") as? ShopScene {
            scene.scaleMode = .resizeFill
            scene.setup(gameViewController: self)
            
            if let view = self.view as! SKView? {
                view.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.up, duration: 0.5))
            }
        }*/
        
        self.performSegue(withIdentifier: "showShop", sender: self)
    }

    func showTutorial() {
        if let scene = SKScene(fileNamed: "Tutorial") as? Tutorial {
            scene.scaleMode = .resizeFill
            scene.gameViewController = self
            
            self.game = scene
            
            if let view = self.view as? SKView {
                view.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 0.5))
            }
        }
    }

    func showMainMenu() {
        if let view = self.view as? SKView {
            
            var transitionDirection = SKTransitionDirection.right
            if(view.scene is Settings) {
                transitionDirection = SKTransitionDirection.left
            }
            
            if let scene = SKScene(fileNamed: "Main") as? Main {
                scene.scaleMode = .resizeFill
                scene.gameViewController = self
                view.presentScene(scene, transition: SKTransition.push(with: transitionDirection, duration: 0.5))
            }
        }
    }

    func showSettings() {
        if let scene = SKScene(fileNamed: "Settings") as? Settings {
            scene.scaleMode = .resizeFill
            scene.gameViewController = self
            
            if let view = self.view as! SKView? {
                view.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 0.5))
            }
        }
    }
}
