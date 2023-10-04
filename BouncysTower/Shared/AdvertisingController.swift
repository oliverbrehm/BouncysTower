//
//  Advertising.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class AdvertisingController {
    static var shared = AdvertisingController()
    
    private let timeToAdvertising = 2 * 60.0; // seconds
    
    private var timePlayed = 0.0
    private var gamesPlayedSinceLastPresent = 0
    
    private var dismissHandler: (() -> Void)?
    
    var waitingTime: Int {
        return 5 // seconds
    }
    
    func gamePlayed(gameTime: Double) {
        self.timePlayed += gameTime
        self.gamesPlayedSinceLastPresent += 1
    }
    
    // returns true if advertising was presented
    func presentIfNeccessary(in viewController: UIViewController, completion: @escaping () -> Void) -> Bool {
        if InAppPurchaseManager.shared.premiumPurchased {
            return false
        }
        
        if(!Config.standard.allTutorialsShown()) {
            // don't show if player is still "learning"
            return false
        }
        
        if(self.gamesPlayedSinceLastPresent >= 2 && self.timePlayed >= timeToAdvertising) {
            self.timePlayed = 0.0
            self.gamesPlayedSinceLastPresent = 0
            self.present(in: viewController)
            self.dismissHandler = completion
            return true
        }
        
        return false
    }
    
    func present(in viewController: UIViewController) {
        viewController.performSegue(withIdentifier: "showPremium", sender: viewController)
    }
    
    func dismiss() {
        self.dismissHandler?()
        self.dismissHandler = nil
    }
}
