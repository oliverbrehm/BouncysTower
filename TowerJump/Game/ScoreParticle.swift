//
//  ScoreParticle.swift
//  TowerJump
//
//  Created by Oliver Brehm on 03.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

// TODO remove class?
class ScoreParticle : SKSpriteNode
{
    private var destination = CGPoint.zero
    
    init()
    {
        super.init(texture: nil, color: SKColor.yellow, size: CGSize(width: 5.0, height: 5.0))
        
        /*self.physicsBody = SKPhysicsBody.init(circleOfRadius: 5.0)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.contactTestBitMask = 0x0
        self.physicsBody?.categoryBitMask = NodeCategories.Particle*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func Start(destination: CGPoint)
    {
        self.destination = destination
        
        /*let dx = Double.random(in: -1.0...1.0)
        let dy = Double.random(in: -1.0...1.0)
        let dr = Double.random(in: 0.0...1.0)
        */
        self.position = CGPoint(x: 0.0, y: 100.0)
        
        /*
        self.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        self.physicsBody?.angularVelocity = CGFloat(dr)
        
        self.run(SKAction.run {
            self.update()
        })*/
    }
    
    private func update() {
        if(self.destination.DistanceTo(point: self.position) < 1.0) {
            self.removeFromParent()
            return
        }
        
        if let p = self.physicsBody {
            let v = self.position.VectorTo(point: self.destination)
            let dx = 0.5 * p.velocity.dx + 0.5 * v.dx
            let dy = 0.5 * p.velocity.dy + 0.5 * v.dy
            p.velocity = CGVector(dx: dx, dy: dy)
        }
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.run {
            self.update()
            }]))
    }
}
