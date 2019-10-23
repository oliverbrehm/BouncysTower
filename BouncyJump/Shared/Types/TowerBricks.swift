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
        case .standardRed, .standardPurple, .standardGreen:
            return 50
        case .standardBlue, .standardOrange, .standardYellow:
            return 60
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
        case .standard:
            return "brickBroken"
        case .standardGreen:
            return "brickBrokenGreen"
        case .standardRed:
            return "brickBrokenRed"
        case .standardPurple:
            return "brickBrokenPurple"
        case .standardBlue:
            return "brickBlue"
        case .standardYellow:
            return "brickYellow"
        case .standardOrange:
            return "brickOrange"
        case .glass:
            return "brickGlass"
        case .diamond:
            return "brickDiamond"
        case .magic:
            return "brickMagic"
        }
    }
    
    var name: String {
        switch self {
        case .standard:
            return Strings.Brick.standardBrickTitle
        case .standardBlue:
            return Strings.Brick.blueBrickTitle
        case .standardRed:
            return Strings.Brick.redBrickTitle
        case .standardGreen:
            return Strings.Brick.greenBrickTitle
        case .standardYellow:
            return Strings.Brick.yellowBrickTitle
        case .standardPurple:
            return Strings.Brick.purpleBrickTitle
        case .standardOrange:
            return Strings.Brick.orangeBrickTitle
        case .glass:
            return Strings.Brick.glassBrickTitle
        case .diamond:
            return Strings.Brick.diamondBrickTitle
        case .magic:
            return Strings.Brick.magicBrickTitle
        }
    }
        
    var description: String {
        switch self {
        case .standard:
            return Strings.Brick.standardBrickDescription
        case .standardBlue:
            return Strings.Brick.blueBrickDescription
        case .standardRed:
            return Strings.Brick.redBrickDescription
        case .standardGreen:
            return Strings.Brick.greenBrickDescription
        case .standardYellow:
            return Strings.Brick.yellowBrickDescription
        case .standardPurple:
            return Strings.Brick.purpleBrickDescription
        case .standardOrange:
            return Strings.Brick.orangeBrickDescription
        case .glass:
            return Strings.Brick.glassBrickDescription
        case .diamond:
            return Strings.Brick.diamondBrickDescription
        case .magic:
            return Strings.Brick.magicBrickDescription
        }
    }
    
    var soundName: String {
        switch self {
        case .standard:
            return "brick_c.aif"
        case .standardRed:
            return "brick_d.aif"
        case .standardBlue:
            return "brick_e.aif"
        case .standardGreen:
            return "brick_f.aif"
        case .standardOrange:
            return "brick_g.aif"
        case .standardPurple:
            return "brick_a.aif"
        case .standardYellow:
            return "brick_bb.aif"
        case .glass:
            return "brick_ice.aif"
        case .diamond:
            return "brick_diamond.aif"
        case .magic:
            return "brick_magic.aif"
        }
    }
    
    var selectAction: SKAction {
        switch self {
        case .standard, .standardRed, .standardBlue, .standardGreen, .standardOrange, .standardPurple, .standardYellow:
            return Brick.growShrinkAction
        case .glass:
            return Brick.shakeAction
        case .diamond:
            return Brick.twistAction
        case .magic:
            return Brick.magicAction
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
    
    private static let shakeRadius: CGFloat = 30.0
    private static let shakeTime: TimeInterval = 0.15
    private static func singleShakeAction(radius: CGFloat) -> SKAction {
        return SKAction.sequence([
            SKAction.moveBy(x: radius / 2, y: 0, duration: shakeTime / 4),
            SKAction.moveBy(x: -radius, y: 0, duration: shakeTime / 2),
            SKAction.moveBy(x: radius / 2, y: 0, duration: shakeTime / 4)
        ])
    }
    private static let shakeAction = SKAction.sequence([
        singleShakeAction(radius: shakeRadius),
        singleShakeAction(radius: shakeRadius / 2),
        singleShakeAction(radius: shakeRadius / 4),
        singleShakeAction(radius: shakeRadius / 8)
    ])
    
    private static let magicAction = SKAction.sequence([
        SKAction.scale(to: 10.0, duration: 0.3),
        SKAction.scale(to: 1.0, duration: 0.3)
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
    
    func reset() {
        self.bricks = []
        self.rows = []
        
        // TODO remove add random bricks
        /*for _ in 0 ..< 12 {
            self.bricks.append(Brick.randomBrick())
        }
        
        for _ in 0 ..< 100 {
            var row: [Brick] = []
            for _ in 0 ..< 5 {
                row.append(Brick.randomBrick())
            }
            self.rows.append(row)
        }*/
    }
}
