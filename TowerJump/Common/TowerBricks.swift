//
//  TowerBricks.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

enum Brick: Int {
    case standard
    case diamond
    
    var cost: Int {
        switch self {
        case .standard:
            return 20
        case .diamond:
            return 40
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
