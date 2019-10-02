//
//  Constants.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 20.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

struct Colors {
    static let menuForeground = SKColor(hex: 0xFFDA0E)
    static let towerBg = SKColor(hex: 0x444444)
    static let cellBg = SKColor(hex: 0x007052)
    static let collectableBacklight = SKColor(hex: 0xFFFBC2)
    static let overlay = SKColor(hex: 0x003B30)
    static let buttonColor = SKColor(hex: 0x2130AA)
    static let buttonPressed = SKColor(hex: 0x6586FF)
    
    static let bgLevel01 = SKColor(hex: 0x257052)
    static let bgLevel02 = SKColor(hex: 0xFF8A50)
}

extension SKColor {
    convenience init(red: Int, green: Int, blue: Int) {
        guard
            red >= 0 && red <= 255,
            green >= 0 && green <= 255,
            blue >= 0 && blue <= 255
        else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
   }

   convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}

extension SKColor {
    static func random(excluding: SKColor? = nil) -> SKColor {
        
        var possibleColors: [SKColor] = [
            SKColor.green,
            SKColor.purple,
            SKColor.orange,
            SKColor.yellow,
            SKColor.red,
            SKColor.blue,
            SKColor.systemTeal,
            SKColor.magenta
        ]
        
        if let excludedColor = excluding, let index = possibleColors.firstIndex(of: excludedColor) {
            possibleColors.remove(at: index)
        }
        
        return possibleColors[Int.random(in: 0 ..< possibleColors.count)]
    }
}
