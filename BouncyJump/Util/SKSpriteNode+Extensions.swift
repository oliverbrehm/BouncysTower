//
//  SpriteNodeExtensions.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 03.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    func top() -> CGFloat {
        return self.position.y + self.frame.size.height / 2.0
    }
    
    func bottom() -> CGFloat {
        return self.position.y - self.frame.size.height / 2.0
    }
    
    func left() -> CGFloat {
        return self.position.x - self.frame.size.width / 2.0
    }
    
    func right() -> CGFloat {
        return self.position.x + self.frame.size.width / 2.0
    }
}

extension CGPoint {
    func distanceTo(point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx*dx + dy*dy)
    }
    
    func vectorTo(point: CGPoint) -> CGVector {
        let dx = point.x - self.x
        let dy = point.y - self.y
        return CGVector(dx: dx, dy: dy)
    }
}
