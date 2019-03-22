//
//  Config.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

enum Tutorial: String, CaseIterable {
    case move = "TUTORIAL_MOVE"
    case wallJump = "TUTORIAL_WALL_JUMP"
    case combos = "TUTORIAL_COMBOS"
    case extraLives = "TUTORIAL_EXTRA_LIVES"
    case bricks = "TUTORIAL_BRICKS"
    case shop = "TUTORIAL_SHOP"
    case towerMultiplicator = "TUTORIAL_TOWER_MULTIPLICATOR"
}

class Config {
    static let standard = Config()
    
    private static let keyExtraLives = "EXTRA_LIVES"
    private static let keyCoins = "COINS"
    private static let keyTutorialShown = "TUTORIAL_SHOWN"
    
    init() {
        self.extraLives = UserDefaults.standard.integer(forKey: Config.keyExtraLives)
        self.coins = UserDefaults.standard.integer(forKey: Config.keyCoins)
    }
        
    private(set) var coins: Int {
        didSet {
            UserDefaults.standard.set(coins, forKey: Config.keyCoins)
            UserDefaults.standard.synchronize()
        }
    }
    
    private(set) var extraLives: Int {
        didSet {
            UserDefaults.standard.set(extraLives, forKey: Config.keyExtraLives)
            UserDefaults.standard.synchronize()
        }
    }
    
    func addCoin() {
        coins += 1
    }
    
    func buyCoins() {
        // TODO in-app purchase here
        coins += 50
    }
    
    func hasExtralives() -> Bool {
        return extraLives > 0
    }
    
    func useExtralive() -> Bool {
        if (extraLives > 0) {
            extraLives -= 1
            return true
        } else {
            return false
        }
    }
    
    func addExtralife() {
        extraLives += 1
    }
    
    func buyExtralife() {
        if(self.coins >= ResourceManager.costExtraLife) {
            self.coins -= ResourceManager.costExtraLife
            addExtralife()
        }
    }
    
    func buyBrick(_ brick: Brick) {
        if(self.coins >= brick.cost) {
            self.coins -= brick.cost
            TowerBricks.standard.add(brick: brick)
        }
    }
    
    func setTutorialShown(_ tutorial: Tutorial) {
        UserDefaults.standard.set(true, forKey: tutorial.rawValue)
    }
    
    func shouldShow(tutorial: Tutorial) -> Bool {
        return !UserDefaults.standard.bool(forKey: tutorial.rawValue)
    }
    
    // returns true if all "level" tutorials were shown
    func allTutorialsShown() -> Bool {
        for tutorial in Tutorial.allCases {
            if(tutorial == .extraLives
                || tutorial == .bricks
                || tutorial == .towerMultiplicator) {
                continue
            }
            
            if(shouldShow(tutorial: tutorial)) {
                return false
            }
        }
        
        return true
    }
}
