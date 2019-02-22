//
//  Advertising.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class AdvertisingController {
    static var Default = AdvertisingController()
    
    private let timeToAdvertising = 1 * 60.0; // seconds
    
    private var timePlayed = 0.0
    
    private var gameView: SKView?
    
    func setup(view: SKView) {
        self.gameView = view
    }
    
    func gamePlayed(gameTime: Double) {
        self.timePlayed += gameTime
    }
    
    func presentIfNeccessary(returnScene: SKScene, completionHandler: @escaping (() -> Void)) {
        if(self.timePlayed >= timeToAdvertising) {
            self.timePlayed = 0.0
            if let scene = SKScene(fileNamed: "Advertising01") as? Advertising {
                scene.scaleMode = .resizeFill
                self.gameView?.presentScene(scene, transition: SKTransition.moveIn(with: SKTransitionDirection.down, duration: 0.5))
                scene.execute {
                    if let view = self.gameView {
                        view.presentScene(returnScene, transition: SKTransition.reveal(with: SKTransitionDirection.up, duration: 0.5))
                        completionHandler()
                    }
                }
            }
        }
    }
}
