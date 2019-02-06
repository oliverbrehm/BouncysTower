//
//  Config.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

class Config {
    private static let _instance = Config()
    
    private static let KEY_EXTRA_LIVES = "EXTRA_LIVES"
    private static let KEY_COINS = "COINS"
    private static let KEY_TUTORIAL_SHOWN = "TUTORIAL_SHOWN"
    
    init() {
        _extraLives = UserDefaults.standard.integer(forKey: Config.KEY_EXTRA_LIVES)
        _coins = UserDefaults.standard.integer(forKey: Config.KEY_COINS)
    }
    
    public static var Default: Config {
        get {
            return _instance
        }
    }
    
    private var _extraLives: Int
    private var _coins: Int
    
    public var TutorialShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Config.KEY_TUTORIAL_SHOWN)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Config.KEY_TUTORIAL_SHOWN)
        }
    }
    
    public var ExtraLives: Int {
        get {
            return _extraLives
        }
    }
    
    public func HasExtralives() -> Bool {
        return _extraLives > 0
    }
    
    public func UseExtralive() -> Bool {
        if (_extraLives > 0) {
            _extraLives = _extraLives - 1
            return true
        } else {
            return false
        }
    }
    
    public func AddExtralife() {
        _extraLives = _extraLives + 1
        UserDefaults.standard.set(_extraLives, forKey: Config.KEY_EXTRA_LIVES)
    }
    
    public var Coins: Int {
        get {
            return _coins
        }
    }
    
    public func AddCoin() {
        _coins = _coins + 1
        UserDefaults.standard.set(_coins, forKey: Config.KEY_COINS)
    }
}
