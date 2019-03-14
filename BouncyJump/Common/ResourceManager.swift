//
//  ResourceManager.swift
//  BouncyJump
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
    
    static let costExtraLife = 300
    
    private let maxCoins = 8
    private var coinsStore = 0
    
    private var nextBrickType = Brick.standard
    private var nextBrickIn = Brick.standard.cost
    
    private var nextExtraLifeIn = ResourceManager.costExtraLife
    
    func advancePlatform() {
        self.coinsStore += 1
        self.nextBrickIn -= 1
        self.nextExtraLifeIn -= 1
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
    
    // returns true if ExtraLife consumed
    func consumeExtraLife() -> Bool {
        if(nextExtraLifeIn <= 0) {
            nextExtraLifeIn = ResourceManager.costExtraLife
            return true
        }
        
        return false
    }
    
    // returns the type of the consumed brick or nil
    func consumeBrick() -> Brick? {
        if(nextBrickIn <= 0) {
            let toConsume = nextBrickType
            self.setNextBrickType()
            nextBrickIn = nextBrickType.cost
            return toConsume
        }
        
        return nil
    }
    
    private func setNextBrickType() {
        let maxRandom = Brick.standard.cost.inverted + Brick.diamond.cost.inverted
        let random = Double.random(in: 0.0 ..< maxRandom)
        
        switch(random) {
        case 0.0 ..< Brick.standard.cost.inverted:
            nextBrickType = Brick.standard
        case Brick.standard.cost.inverted ..< Brick.standard.cost.inverted + Brick.diamond.cost.inverted:
            nextBrickType = Brick.diamond
        default:
            nextBrickType = Brick.standard
        }
    }
}
