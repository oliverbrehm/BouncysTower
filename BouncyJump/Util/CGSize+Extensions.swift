//
//  CGSize+Extensions.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 22.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

extension CGSize {
    static func * (factor: CGFloat, size: CGSize) -> CGSize {
        return CGSize(width: size.width * factor, height: size.height * factor)
    }
    
    static func * (size: CGSize, factor: CGFloat) -> CGSize {
        return factor * size
    }
}
