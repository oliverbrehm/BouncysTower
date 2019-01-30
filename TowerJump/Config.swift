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
    
    public static var Default: Config {
        get {
            return _instance
        }
    }
    
    private var _extraLives = 3
    
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
}
