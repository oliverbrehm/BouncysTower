//
//  Config.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

enum Tutorial: String, CaseIterable {
    case move = "TUTORIAL_MOVE"
    case roll1 = "TUTORIAL_ROLL1"
    case roll2 = "TUTORIAL_ROLL2"
    case wallJump1 = "TUTORIAL_WALL_JUMP1"
    case wallJump2 = "TUTORIAL_WALL_JUMP2"
    case combos1 = "TUTORIAL_COMBOS1"
    case combos2 = "TUTORIAL_COMBOS2"
    case extraLives = "TUTORIAL_EXTRA_LIVES"
    case bricks = "TUTORIAL_BRICKS"
    case shop = "TUTORIAL_SHOP"
    case towerMultiplicator = "TUTORIAL_TOWER_MULTIPLICATOR"
    
    var message: String {
        switch self {
        case .move:
            return Strings.Tutorial.moveTutorialDescription
        case .roll1:
            return Strings.Tutorial.rollTutorialDescription1
        case .roll2:
            return Strings.Tutorial.rollTutorialDescription2
        case .wallJump1:
            return Strings.Tutorial.wallTutorialDescription1
        case .wallJump2:
            return Strings.Tutorial.wallTutorialDescription2
        case .combos1:
            return Strings.Tutorial.combosTutorialDescription1
        case .combos2:
            return Strings.Tutorial.combosTutorialDescription2
        case .bricks:
            return Strings.Tutorial.bricksTutorialDescription
        case .extraLives:
            return Strings.Tutorial.extraLivesTutorialDescription
        case .towerMultiplicator:
            return Strings.Tutorial.towerMultiplicatorTutorialDescription
        case .shop:
            return Strings.MenuMain.visitStoreMessage
        }
    }
    
    var imageName: String? {
        switch self {
        case .move:
            return "leftright"
        case .roll1:
            return "player"
        case .roll2:
            return "roll"
        case .wallJump1:
            return "roll"
        case .wallJump2:
            return "comboWall"
        case .combos1:
            return "combo"
        case .combos2:
            return "comboWall"
        case .bricks:
            return Brick.standard.textureName
        case .extraLives:
            return "extralife"
        case .towerMultiplicator:
            return "combo"
        case .shop:
            return "coin"
        }
    }
    
    var imageHeight: CGFloat {
        switch self {
        case .move:
            return 80.0
        case .roll1:
            return 50.0
        case .roll2:
            return 120.0
        case .wallJump1:
            return 120.0
        case .wallJump2:
            return 120.0
        case .combos1:
            return 120.0
        case .combos2:
            return 120.0
        case .bricks:
            return 50.0
        case .extraLives:
            return 50.0
        case .towerMultiplicator:
            return 50.0
        case .shop:
            return 50.0
        }
    }
}

class Config {
    static let standard = Config()
    
    private static let keyExtraLives = "EXTRA_LIVES"
    private static let keyCoins = "COINS"
    private static let keyTutorialShown = "TUTORIAL_SHOWN"
    
    init() {
        self.extraLives = UserDefaults.standard.integer(forKey: Config.keyExtraLives)
        self.coins = UserDefaults.standard.integer(forKey: Config.keyCoins)
    }
        
    private(set) var coins: Int {
        didSet {
            UserDefaults.standard.set(coins, forKey: Config.keyCoins)
            UserDefaults.standard.synchronize()
        }
    }
    
    private(set) var extraLives: Int {
        didSet {
            UserDefaults.standard.set(extraLives, forKey: Config.keyExtraLives)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var screenWidthFactor: CGFloat {
        return UIScreen.main.nativeBounds.height / UIScreen.main.nativeBounds.width
    }

    static var isIphoneX: Bool {
        let deviceHeight = UIScreen.main.nativeBounds.height
        return [2436, 2688, 1792].contains(deviceHeight)
    }
    
    static var roundedDisplayMargin: CGFloat {
        return isIphoneX ? 10 : 0
    }
    
    func addCoin() {
        coins += 1
    }
    
    func addCoins(_ number: Int) {
        coins += number
    }
    
    func hasExtralives() -> Bool {
        return extraLives > 0
    }
    
    func useExtralive() -> Bool {
        if (extraLives > 0) {
            extraLives -= 1
            return true
        } else {
            return false
        }
    }
    
    func addExtralife() {
        extraLives += 1
    }
    
    func buyExtralife() {
        if(self.coins >= ResourceManager.costExtraLife) {
            self.coins -= ResourceManager.costExtraLife
            addExtralife()
        }
    }
    
    func debugBuyLotsOfBricks() {
        for _ in 1...200 {
            buyBrick(.standard)
        }
    }
    
    func buyBrick(_ brick: Brick) {
        if(self.coins >= brick.cost) {
            self.coins -= brick.cost
            TowerBricks.standard.add(brick: brick)
        }
    }
    
    func setTutorialShown(_ tutorial: Tutorial) {
        UserDefaults.standard.set(true, forKey: tutorial.rawValue)
    }
    
    func shouldShow(tutorial: Tutorial) -> Bool {
        return !UserDefaults.standard.bool(forKey: tutorial.rawValue)
    }
    
    // returns true if all "level" tutorials were shown
    func allTutorialsShown() -> Bool {
        for tutorial in Tutorial.allCases {
            guard
                tutorial == .move ||
                tutorial == .roll1 ||
                tutorial == .wallJump1 ||
                tutorial == .combos1 else
            {
                    continue
            }
            
            if(shouldShow(tutorial: tutorial)) {
                return false
            }
        }
        
        return true
    }
    
    func reset() {
        self.coins = 0
        self.extraLives = 0
        
        for tutorial in Tutorial.allCases {
            UserDefaults.standard.set(false, forKey: tutorial.rawValue)
        }
    }
}
