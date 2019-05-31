//
//  Config.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

enum Tutorial: String, CaseIterable {
    case move = "TUTORIAL_MOVE"
    case wallJump = "TUTORIAL_WALL_JUMP"
    case combos = "TUTORIAL_COMBOS"
    case extraLives = "TUTORIAL_EXTRA_LIVES"
    case bricks = "TUTORIAL_BRICKS"
    case shop = "TUTORIAL_SHOP"
    case towerMultiplicator = "TUTORIAL_TOWER_MULTIPLICATOR"
    
    var message: String {
        switch self {
        case .move:
            return "Touch and hold to move. "
                + "Use the entire left half of the screen to move left and the right half to move right. "
                + "You move faster the longer you touch the screen."
            
        case .wallJump:
            return "Great, you reached the next Level! Did you notice: "
                + "You get an extra boost upwards if you jump against the wall! "
                + "If you roll left or right on the platform, you gain more speed and jump higher."
            
        case .combos:
            return "Nice jumping! You get an even higher score if you do combos. "
                + "Always keep rolling by holding your touch while on the platform. "
                + "To get a combo you have to jump at least two platforms at once "
                + "and hit the left or right wall between each jump."
            
        case .bricks:
            return "Cool, you collected a loose brick! "
                + "Use it in the main screen to build your own personal tower."
            
        case .extraLives:
            return "Hey, you found an extra life! "
                + "If you fall down, you can decide to use it and it will save you once."
            
        case .towerMultiplicator:
            return "x2\n\n"
                + "Awesome, your tower is growing!\n"
                + "You even get a higher in-game score the taller the tower gets. "
                + "The score for each jump will be multiplied by the height of your tower."
            
        default:
            return ""
        }
    }
    
    var imageName: String? {
        switch self {
        case .move:
            return "leftright"
            
        case .combos:
            return "combo"
            
        case .extraLives:
            return "extralife"
        default:
            return nil
        }
    }
    
    var imageHeight: CGFloat {
        switch self {
        case .move:
            return 80.0
            
        case .combos:
            return 160.0
            
        case .bricks:
            return 50.0
            
        case .extraLives:
            return 50.0
        default:
            return 0
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
    
    func buyCoins() {
        // TODO in-app purchase here
        coins += 50
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
            if(tutorial == .extraLives
                || tutorial == .bricks
                || tutorial == .towerMultiplicator) {
                continue
            }
            
            if(shouldShow(tutorial: tutorial)) {
                return false
            }
        }
        
        return true
    }
}
