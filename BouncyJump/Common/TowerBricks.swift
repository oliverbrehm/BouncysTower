//
//  TowerBricks.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 02.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

enum Brick: Int, CaseIterable {
    case standard
    case diamond
    
    var cost: Int {
        switch self {
        case .standard:
            return 100
        case .diamond:
            return 250
        }
    }
    
    var textureName: String {
        switch self {
        case .standard:
            return "brick"
        case .diamond:
            return "brick2"
        }
    }
    
    var name: String {
        switch self {
        case .standard:
            return "Brick"
        case .diamond:
            return "Diamond Brick"
        }
    }
        
    var description: String {
        switch self {
        case .standard:
            return "Use it to build your personal tower"
        case .diamond:
            return "Fancy brick for your tower"
        }
    }
    
    var soundName: String {
        switch self {
        case .standard:
            return "brick_standard.aif"
        case .diamond:
            return "brick_diamond.aif"
        }
    }
    
    var selectAction: SKAction {
        switch self {
        case .standard:
            return SKAction.sequence([
                SKAction.scale(to: 1.2, duration: 0.2),
                SKAction.wait(forDuration: 0.2),
                SKAction.scale(to: 1.0, duration: 0.2)
            ])
        case .diamond:
            return SKAction.sequence([
                SKAction.scale(to: 1.3, duration: 0.2),
                SKAction.rotate(byAngle: 2 * CGFloat.pi, duration: 0.2),
                SKAction.scale(to: 1.0, duration: 0.2)
                ])
        }
    }
}

class TowerBricks {
    static let standard = TowerBricks()
    
    static let numberOfBricksInRow = 5
    static let keyBricks = "TOWER_BRICKS"
    static let keyRows = "TOWER_ROWS"
    
    private(set) var rows: [[Brick]] = [] {
        didSet {
            let rowValues = rows.map { $0.map { $0.rawValue } }
            UserDefaults.standard.set(rowValues, forKey: TowerBricks.keyRows)
            UserDefaults.standard.synchronize()
            
            Score.standard.towerHeight = rows.count
        }
    }
    
    private(set) var bricks: [Brick] = [] {
        didSet {
            let brickValues = bricks.map { $0.rawValue }
            UserDefaults.standard.set(brickValues, forKey: TowerBricks.keyBricks)
            UserDefaults.standard.synchronize()
        }
    }
    
    var numberOfBricks: Int {
        return bricks.count
    }
    
    init() {
        let rowValues = UserDefaults.standard.array(forKey: TowerBricks.keyRows) as? [[Int]] ?? []
        self.rows = rowValues.map { $0.map {Brick(rawValue: $0) ?? Brick.standard}}
        
        let brickValues = UserDefaults.standard.array(forKey: TowerBricks.keyBricks) as? [Int] ?? []
        self.bricks = brickValues.map { Brick(rawValue: $0) ?? Brick.standard}
    }
    
    func add(brick: Brick) {
        self.bricks += [brick]
    }
    
    var canBuildRow: Bool {
        return self.bricks.count >= TowerBricks.numberOfBricksInRow
    }
    
    func buildRow() {
        if(self.canBuildRow) {
            self.rows += [Array(bricks[0 ..< TowerBricks.numberOfBricksInRow])]
            self.bricks.removeFirst(TowerBricks.numberOfBricksInRow)
        }
    }
}
