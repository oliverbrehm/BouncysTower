//
//  ResourceManager.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 04.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

extension Int {
    var inverted: Double {
        return 1.0 / Double(self)
    }
}

class ResourceManager {
    static let standard = ResourceManager()
    
    static let costExtraLife = 400
    static var superCoinTimeout: Int {
        return 20 + Int.random(in: -5 ... 5)
    }
    static var superJumpTimeout: Int {
        return 35 + Int.random(in: -10 ... 10)
    }
    
    private let maxCoins = 8
    private var coinsStore = 0
    
    private var nextBrickType = Brick.standard
    private var nextBrickIn = 70
    
    private var nextExtraLifeIn = ResourceManager.costExtraLife
    private var nextSuperCoinIn = ResourceManager.superCoinTimeout
    private var nextSuperJumpIn = ResourceManager.superJumpTimeout
    
    func advancePlatform() {
        self.coinsStore += 1
        self.nextBrickIn -= 1
        self.nextExtraLifeIn -= 1
        self.nextSuperCoinIn -= 1
    }
    
    func advanceSuperJumpConsumable() {
        self.nextSuperJumpIn -= 1
    }
    
    // returns the number of consumed coins
    func consumeCoins() -> Int {
        var toConsume = 0
        
        if(coinsStore >= maxCoins) {
            toConsume = coinsStore
        } else if(coinsStore < 3) {
            return 0
        } else {
            let random = Double.random(in: 0.0 ..< Double(maxCoins + 1 - coinsStore))
            if(random < 1.0) {
                toConsume = coinsStore
            }
        }
        
        coinsStore -= toConsume
        return toConsume
    }
    
    func consumeExtraLife() -> Bool {
        if(nextExtraLifeIn <= 0) {
            nextExtraLifeIn = ResourceManager.costExtraLife / 2 + Int.random(in: -10 ... 10)
            return true
        }
        
        return false
    }
    
    func consumeSuperCoin() -> Bool {
        if(nextSuperCoinIn <= 0) {
            nextSuperCoinIn = ResourceManager.superCoinTimeout
            return true
        }
        
        return false
    }
    
    func consumeSuperJump() -> Bool {
        if(nextSuperJumpIn <= 0) {
            nextSuperJumpIn = ResourceManager.superJumpTimeout
            return true
        }
        
        return false
    }
    
    // returns the type of the consumed brick or nil
    func consumeBrick() -> Brick? {
        if(nextBrickIn <= 0) {
            let toConsume = nextBrickType
            self.setNextBrickType()
            nextBrickIn = 70 + Int.random(in: 0 ... 30)
            return toConsume
        }
        
        return nil
    }
    
    private func setNextBrickType() {
        nextBrickType = Brick.randomBrick()
    }
}
