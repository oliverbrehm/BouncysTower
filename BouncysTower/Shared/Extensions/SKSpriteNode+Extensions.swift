//
//  SpriteNodeExtensions.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 03.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    var top: CGFloat {
        return self.position.y + self.frame.size.height / 2.0
    }
    
    var bottom: CGFloat {
        return self.position.y - self.frame.size.height / 2.0
    }
    
    var left: CGFloat {
        return self.position.x - self.frame.size.width / 2.0
    }
    
    var right: CGFloat {
        return self.position.x + self.frame.size.width / 2.0
    }
    
    convenience init(texture: SKTexture, color: SKColor, width: CGFloat) {
        let size = CGSize(width: width, height: width * texture.size().height / texture.size().width)
        self.init(texture: texture, color: color, size: size)
    }
    
    convenience init(texture: SKTexture, color: SKColor, height: CGFloat) {
        let size = CGSize(width: height * texture.size().width / texture.size().height, height: height)
        self.init(texture: texture, color: color, size: size)
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
