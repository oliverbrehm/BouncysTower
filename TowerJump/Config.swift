//
//  Config.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

class Config {
    static let standard = Config()
    
    private static let keyExtraLives = "EXTRA_LIVES"
    private static let keyCoins = "COINS"
    private static let keyTutorialShown = "TUTORIAL_SHOWN"
    
    init() {
        _extraLives = UserDefaults.standard.integer(forKey: Config.keyExtraLives)
        _coins = UserDefaults.standard.integer(forKey: Config.keyCoins)
    }
    
    private var _extraLives: Int
    private var _coins: Int
    
    var tutorialShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Config.keyTutorialShown)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Config.keyTutorialShown)
        }
    }
    
    var extraLives: Int {
        get {
            return _extraLives
        }
    }
    
    func hasExtralives() -> Bool {
        return _extraLives > 0
    }
    
    func useExtralive() -> Bool {
        if (_extraLives > 0) {
            _extraLives = _extraLives - 1
            return true
        } else {
            return false
        }
    }
    
    func addExtralife() {
        _extraLives = _extraLives + 1
        UserDefaults.standard.set(_extraLives, forKey: Config.keyExtraLives)
    }
    
    var coins: Int {
        get {
            return _coins
        }
    }
    
    func addCoin() {
        _coins = _coins + 1
        UserDefaults.standard.set(_coins, forKey: Config.keyCoins)
    }
}
