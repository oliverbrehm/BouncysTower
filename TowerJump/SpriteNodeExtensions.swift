//
//  SpriteNodeExtensions.swift
//  TowerJump
//
//  Created by Oliver Brehm on 03.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    func Top() -> CGFloat
    {
        return self.position.y + self.frame.size.height / 2.0
    }
    
    func Bottom() -> CGFloat
    {
        return self.position.y - self.frame.size.height / 2.0
    }
    
    func Left() -> CGFloat
    {
        return self.position.x - self.frame.size.width / 2.0
    }
    
    func Right() -> CGFloat
    {
        return self.position.x + self.frame.size.width / 2.0
    }
}

extension CGPoint {
    func DistanceTo(point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx*dx + dy*dy)
    }
    
    func VectorTo(point: CGPoint) -> CGVector {
        let dx = point.x - self.x
        let dy = point.y - self.y
        return CGVector(dx: dx, dy: dy)
    }
}
