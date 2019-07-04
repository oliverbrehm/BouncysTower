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
    case standardBlue
    case standardRed
    case standardGreen
    case standardYellow
    case standardPurple
    case standardOrange
    case glass
    case diamond
    case magic
    
    var cost: Int {
        switch self {
        case .standard:
            return 40
        case .standardRed, .standardBlue, .standardGreen, .standardOrange, .standardPurple, .standardYellow:
            return 50
        case .glass:
            return 80
        case .diamond:
            return 120
        case .magic:
            return 250
        }
    }
    
    var textureName: String {
        switch self {
        case .standard, .standardRed, .standardBlue, .standardGreen, .standardOrange, .standardPurple, .standardYellow:
            return "brick"
        case .glass:
            return "brick" // TODO
        case .diamond:
            return "brick2" // TODO
        case .magic:
            return "brick" // TODO
        }
    }
    
    var name: String {
        switch self {
        case .standard:
            return "Brick"
        case .standardBlue:
            return "Blue brick"
        case .standardRed:
            return "Red brick"
        case .standardGreen:
            return "Green brick"
        case .standardYellow:
            return "Yellow brick"
        case .standardPurple:
            return "Purple brick"
        case .standardOrange:
            return "Orange brick"
        case .glass:
            return "Glass brick"
        case .diamond:
            return "Diamond brick"
        case .magic:
            return "Magic brick"
        }
    }
        
    var description: String {
        switch self {
        case .standard:
            return "Use it to build your personal tower"
        case .standardBlue:
            return "Colorful blue brick"
        case .standardRed:
            return "Colorful red brick"
        case .standardGreen:
            return "Colorful green brick"
        case .standardYellow:
            return "Colorful yellow brick"
        case .standardPurple:
            return "Colorful purple brick"
        case .standardOrange:
            return "Colorful orange brick"
        case .glass:
            return "Bick made of glass"
        case .diamond:
            return "Fancy diamond brick for your tower"
        case .magic:
            return "?)$#%(*?#)@(#*% )#W%  )#(% ##%#%"
        }
    }
    
    var color: SKColor? {
        switch self {
        case .standardBlue:
            return SKColor.blue
        case .standardRed:
            return SKColor.red
        case .standardGreen:
            return SKColor.green
        case .standardYellow:
            return SKColor.yellow
        case .standardPurple:
            return SKColor.purple
        case .standardOrange:
            return SKColor.orange
        default:
            return nil
        }
    }
    
    var soundName: String {
        switch self {
        case .standard, .standardRed, .standardBlue, .standardGreen, .standardOrange, .standardPurple, .standardYellow:
            return "brick_standard.aif"
        case .glass:
            return "brick_diamond.aif" // TODO
        case .diamond:
            return "brick_diamond.aif"
        case .magic:
            return "brick_diamond.aif" // TODO
        }
    }
    
    var selectAction: SKAction {
        switch self {
        case .standard, .standardRed, .standardBlue, .standardGreen, .standardOrange, .standardPurple, .standardYellow:
            return Brick.growShrinkAction
        case .glass:
            return Brick.twistAction // TODO
        case .diamond:
            return Brick.twistAction
        case .magic:
            return Brick.twistAction // TODO
        }
    }
    
    static func randomBrick() -> Brick {
        let random = Double.random(in: 0.0 ..< maxRandom)
        
        for brick in Brick.allCases {
            if brick.randomRange.contains(random) {
                return brick
            }
        }
        
        return .standard
    }
    
    private var randomRange: ClosedRange<Double> {
        return Brick.randomRanges[self] ?? (0 ... 0)
    }
    
    private static var maxRandom: Double {
        var sum = 0.0
        
        for brick in Brick.allCases {
            sum += brick.cost.inverted
        }
        
        return sum
    }
    
    private static let randomRanges: [Brick: ClosedRange<Double>] = {
        var ranges: [Brick: ClosedRange<Double>] = [:]
        
        var lowerBound = 0.0
        
        for brick in Brick.allCases {
            let probability = brick.cost.inverted
            let upperBound = lowerBound + probability
            let range = lowerBound ... upperBound
            
            ranges[brick] = range
            lowerBound = upperBound
        }
        
        return ranges
    }()
    
    private static let growShrinkAction = SKAction.sequence([
        SKAction.scale(to: 1.2, duration: 0.2),
        SKAction.wait(forDuration: 0.2),
        SKAction.scale(to: 1.0, duration: 0.2)
    ])
    
    private static let twistAction = SKAction.sequence([
        SKAction.scale(to: 1.3, duration: 0.2),
        SKAction.rotate(byAngle: 2 * CGFloat.pi, duration: 0.2),
        SKAction.scale(to: 1.0, duration: 0.2)
    ])
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
