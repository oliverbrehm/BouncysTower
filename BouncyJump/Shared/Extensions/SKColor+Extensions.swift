//
//  SKColor+Extensions.swift
//  BouncyJump iOS
//
//  Created by Oliver Brehm on 01.10.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

extension SKColor {
    static var random: SKColor {
        
        let possibleColors: [SKColor] = [
            SKColor.green,
            SKColor.purple,
            SKColor.orange,
            SKColor.yellow,
            SKColor.red,
            SKColor.blue,
            SKColor.systemTeal,
            SKColor.magenta
        ]
        
        return possibleColors[Int.random(in: 0 ..< possibleColors.count)]
    }
}
