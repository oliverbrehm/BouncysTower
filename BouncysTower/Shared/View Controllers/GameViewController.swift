//
//  GameViewController.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 12.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var game: Game?
    
    var sceneSize: CGSize {
        let fixedHeight: CGFloat = 450
        
        // native screen bounds return portrait dimensions, but game runs in landscape mode
        let screenWidth = UIScreen.main.bounds.height
        let screenHeight = UIScreen.main.bounds.width
        
        let width = screenHeight / screenWidth * fixedHeight
        
        return CGSize(width: width, height: fixedHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true
            
            #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
            #endif
        }
        
        GameCenterManager.standard.presentingViewController = self
        GameCenterManager.standard.authenticate { success in
            if !success {
                print("Error authenticating with GameCenter")
            }
        }
        
        showMainMenu()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .top
    }

    func showGame() {
        if let scene = SKScene(fileNamed: "MainGame") as? MainGame {
            scene.size = sceneSize
            scene.scaleMode = .fill
            scene.gameViewController = self
            
            self.game = scene
            
            if let view = self.view as? SKView {
                view.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 0.5))
            }
        }
    }
    
    weak var shopDelegate: ShopDelegate?
    
    func showShop(delegate: ShopDelegate? = nil) {
        self.shopDelegate = delegate
        self.performSegue(withIdentifier: "showShop", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showShop") {
            if let vc = segue.destination as? ShopViewController {
                vc.delegate = self.shopDelegate
            }
        } else if(segue.identifier == "showPremium") {
            if let vc = segue.destination as? PremiumViewController {
                vc.setCountdown(seconds: AdvertisingController.shared.waitingTime)
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
                scene.size = sceneSize
                scene.scaleMode = .fill
                scene.gameViewController = self
                view.presentScene(scene, transition: SKTransition.push(with: transitionDirection, duration: 0.5))
                AudioManager.standard.playBackgroundMusic(backgroundMusic: .menu)
            }
        }
    }

    func showSettings() {
        if let scene = SKScene(fileNamed: "Settings") as? Settings {
            scene.size = sceneSize
            scene.scaleMode = .fill
            scene.gameViewController = self
            
            if let view = self.view as! SKView? {
                view.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 0.5))
            }
        }
    }
}
