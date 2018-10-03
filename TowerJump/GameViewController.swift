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
                view.presentScene(scene)
            }
        }
    }
    
    public func ShowMainMenu()
    {
        if let scene = SKScene(fileNamed: "MainMenu") as? MainMenu {
            scene.scaleMode = .resizeFill
            scene.GameViewController = self
            
            if let view = self.view as! SKView? {
                view.presentScene(scene)
            }
        }
    }
    
    public func ShowCredits()
    {
        if let scene = SKScene(fileNamed: "Credits") as? Credits {
            scene.scaleMode = .resizeFill
            scene.GameViewController = self
            
            if let view = self.view as! SKView? {
                view.presentScene(scene)
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
