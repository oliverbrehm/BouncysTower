//
//  Strings.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 08.07.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

class Strings {
    static let backTitle = NSLocalizedString("backTitle", comment: "BACK")

    struct Brick {
        static let standardBrickTitle = NSLocalizedString("standardBrickTitle", comment: "Standard Brick")
        static let blueBrickTitle = NSLocalizedString("blueBrickTitle", comment: "Blue Brick")
        static let redBrickTitle = NSLocalizedString("redBrickTitle", comment: "Red Brick")
        static let greenBrickTitle = NSLocalizedString("greenBrickTitle", comment: "Green Brick")
        static let yellowBrickTitle = NSLocalizedString("yellowBrickTitle", comment: "Yellow Brick")
        static let purpleBrickTitle = NSLocalizedString("purpleBrickTitle", comment: "Purple Brick")
        static let orangeBrickTitle = NSLocalizedString("orangeBrickTitle", comment: "Orange Brick")
        static let glassBrickTitle = NSLocalizedString("glassBrickTitle", comment: "Glass Brick")
        static let diamondBrickTitle = NSLocalizedString("diamondBrickTitle", comment: "Diamond Brick")
        static let magicBrickTitle = NSLocalizedString("magicBrickTitle", comment: "Magic Brick")
   
        static let standardBrickDescription = NSLocalizedString("standardBrickDescription", comment: "Description sentence for Standard Brick")
        static let blueBrickDescription = NSLocalizedString("blueBrickDescription", comment: "Description sentence for Blue Brick")
        static let redBrickDescription = NSLocalizedString("redBrickDescription", comment: "Description sentence for Red Brick")
        static let greenBrickDescription = NSLocalizedString("greenBrickDescription", comment: "Description sentence for Green Brick")
        static let yellowBrickDescription = NSLocalizedString("yellowBrickDescription", comment: "Description sentence for Yellow Brick")
        static let purpleBrickDescription = NSLocalizedString("purpleBrickDescription", comment: "Description sentence for Purple Brick")
        static let orangeBrickDescription = NSLocalizedString("orangeBrickDescription", comment: "Description sentence for Orange Brick")
        static let glassBrickDescription = NSLocalizedString("glassBrickDescription", comment: "Description sentence for Glass Brick")
        static let diamondBrickDescription = NSLocalizedString("diamondBrickDescription", comment: "Description sentence for Diamond Brick")
        static let magicBrickDescription = "?)#%(*?#)@(#*% )#W%  )#(% ##%#%"
    }
    
    struct Tutorial {
        static let moveTutorialDescription = NSLocalizedString("moveTutorialDescription", comment: "Description sentence for Move Tutorial")
        static let wallTutorialDescription = NSLocalizedString("wallTutorialDescription", comment: "Description sentence for Wall Tutorial")
        static let combosTutorialDescription = NSLocalizedString("combosTutorialDescription", comment: "Description sentence for Combos Tutorial")
        static let bricksTutorialDescription = NSLocalizedString("bricksTutorialDescription", comment: "Description sentence for Bricks Tutorial")
        static let extraLivesTutorialDescription = NSLocalizedString(
            "extraLivesTutorialDescription",
            comment: "Description sentence for Extra lives Tutorial")
        static let towerMultiplicatorTutorialDescription = NSLocalizedString(
            "towerMultiplicatorTutorialDescription",
            comment: "Description sentence for Tower Multiplicator Tutorial")
    }
    
    struct GameElements {
        static let comboPerfectMessage = NSLocalizedString("comboPerfectMessage", comment: "Perfect!")
        static let comboAwesomeMessage = NSLocalizedString("comboAwesomeMessage", comment: "AWESOME")
    }
    
    struct GameOverlay {
        static let rankLabel = NSLocalizedString("rankLabel", comment: "RANK")
        static let newHighscoreLabel = NSLocalizedString("newHighscoreLabel", comment: "NEW HIGHSCORE")
        static let pausedLabel = NSLocalizedString("pausedLabel", comment: "PAUSED")
        static let useExtralifeQuestion = NSLocalizedString("useExtralifeQuestion", comment: "Use extralife?")
    }
    
    struct MenuSettings {
        static let noScoresMessage = NSLocalizedString("noScoresMessage", comment: "No scores yet...")
    }
    
    struct MenuMain {
        static let visitStoreMessage = NSLocalizedString("visitStoreMessage", comment: "Visit store reminder sentence")
        static let shopTitle = NSLocalizedString("shopTitle", comment: "SHOP")
        static let startTitle = NSLocalizedString("startTitle", comment: "PLAY")
        static let secondMenuTitle = NSLocalizedString("secondMenuTitle", comment: "SCORES")
        static let towerHeightRestrictionMessage = NSLocalizedString(
            "towerHeightRestrictionMessage",
            comment: "Tower height restriction in free version sentence")
        static let buildTowerInfoMessage = NSLocalizedString("buildTowerInfoMessage", comment: "Build tower info sentence")
        static let towerHeightLabel = NSLocalizedString("towerHeightLabel", comment: "Tower height")
        static let bricksLeftLabel = NSLocalizedString("bricksLeftLabel", comment: "Bricks left")
    }
}
