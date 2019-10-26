//
//  CoinManager.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 22.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class CoinManager {
    private var coins: [Coin] = []
    
    private var world: World?
    
    func setup(world: World) {
        self.world = world
    }
    
    func spawnCoin(position: CGPoint) {
        if let w = self.world {
            let coin = Coin(manager: self)
            coin.position = position
            w.addChild(coin)
            self.coins.append(coin)
        }
    }
    
    func spawnHorizontalLine(origin: CGPoint, width: CGFloat, n: Int) {
        let d = width / CGFloat(n - 1)
        var x = -width / 2.0
        
        var i = 0
        while i < n {
            self.spawnCoin(position: CGPoint(x: origin.x + x, y: origin.y))
            x += d
            i += 1
        }
    }
    
    func spawnSquare(origin: CGPoint, distanceBetween: CGFloat, nSide: Int) {
        let sideLength = CGFloat(nSide) * Coin.size + CGFloat(nSide - 1) * distanceBetween
        
        var x: CGFloat = origin.x - sideLength / 2.0
        var y: CGFloat = origin.y - sideLength / 2.0
        for _ in 0 ..< nSide {
            for _ in 0 ..< nSide {
                self.spawnCoin(position: CGPoint(x: x + Coin.size / 2.0, y: y + Coin.size / 2.0))
                x += Coin.size + distanceBetween
            }
            x = origin.x - sideLength / 2.0
            y += Coin.size + distanceBetween
        }
    }
    
    func numberOfCoins() -> Int {
        return self.coins.count
    }
    
    func removeCoinsUnder(player: Player) {
        while let coin = self.coins.first, coin.position.y < player.position.y - (world?.height ?? 500.0) {
            self.removeCoin(coin: coin)
        }
    }
    
    func removeCoin(coin: Coin) {
        coin.removeFromParent()

        if let index = self.coins.firstIndex(of: coin) {
            self.coins.remove(at: index)
        }
    }
}
