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
        return self.position.x - self.frame.size.width / 2.0
    }
}
