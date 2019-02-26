//
//  Config.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

struct Prices {
    let extralife = 200
    let brick = 50
}

class Config {
    static let standard = Config()
    
    private static let prices = Prices()
    
    private static let keyExtraLives = "EXTRA_LIVES"
    private static let keyCoins = "COINS"
    private static let keyTutorialShown = "TUTORIAL_SHOWN"
    private static let keyBricks = "BRICKS"
    
    init() {
        self.extraLives = UserDefaults.standard.integer(forKey: Config.keyExtraLives)
        self.coins = UserDefaults.standard.integer(forKey: Config.keyCoins)
        self.bricks = UserDefaults.standard.integer(forKey: Config.keyBricks)
    }
    
    var tutorialShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Config.keyTutorialShown)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Config.keyTutorialShown)
            UserDefaults.standard.synchronize()
        }
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
    
    private(set) var bricks: Int {
        didSet {
            UserDefaults.standard.set(bricks, forKey: Config.keyBricks)
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
        if(self.coins >= Config.prices.extralife) {
            self.coins -= Config.prices.extralife
            addExtralife()
        }
    }
    
    func addBrick() {
        bricks += 1
    }
    
    func buyBrick() {
        if(self.coins >= Config.prices.brick) {
            self.coins -= Config.prices.brick
            addBrick()
        }
    }
}
