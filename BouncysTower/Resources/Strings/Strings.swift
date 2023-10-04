//
//  Strings.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 08.07.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

class Strings {
    static let backTitle = NSLocalizedString("backTitle", comment: "BACK")
    static let continueLabel = NSLocalizedString("continueLabel", comment: "CONTINUE")

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
    
    struct Scores {
        static let rankLabel = NSLocalizedString("rankLabel", comment: "RANK")
        static let newHighscoreLabel = NSLocalizedString("newHighscoreLabel", comment: "NEW HIGHSCORE")
        static let longestComboLabel = NSLocalizedString("longestComboLabel", comment: "Longest combo")
        static let highestJumpLabel = NSLocalizedString("highestJumpLabel", comment: "Highest jump")
    }
    
    struct Tutorial {
        static let moveTutorialDescription = NSLocalizedString("moveTutorialDescription", comment: "Description sentence for Move Tutorial")
        static let rollTutorialDescription1 = NSLocalizedString("rollTutorialDescription1", comment: "Description sentence for Roll Tutorial 1")
        static let rollTutorialDescription2 = NSLocalizedString("rollTutorialDescription2", comment: "Description sentence for Roll Tutorial 2")
        static let wallTutorialDescription1 = NSLocalizedString("wallTutorialDescription1", comment: "Description sentence for Wall Tutorial 1")
        static let wallTutorialDescription2 = NSLocalizedString("wallTutorialDescription2", comment: "Description sentence for Wall Tutorial 2")
        static let combosTutorialDescription1 = NSLocalizedString("combosTutorialDescription1", comment: "Description sentence for Combos Tutorial 1")
        static let combosTutorialDescription2 = NSLocalizedString("combosTutorialDescription2", comment: "Description sentence for Combos Tutorial 2")
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
    
    struct Shop {
        static let buyPremiumTitle = NSLocalizedString("buyPremiumTitle", comment: "Buy premium")
        static let buyPremiumDescription = NSLocalizedString("buyPremiumDescription", comment: "For no more reminders to buy and a good concience")
        static let extralifeTitle = NSLocalizedString("extralifeTitle", comment: "Extra life")
        static let extralifeDescription = NSLocalizedString("extralifeDescription", comment: "Saves you once from falling down")
        static let insufficientCoinsTitle = NSLocalizedString("insufficientCoinsTitle", comment: "Not enough coins")
        static let confirmBuyTitle = NSLocalizedString("confirmBuyTitle", comment: "Buy")
        static let noThanksMessage = NSLocalizedString("noThanksMessage", comment: "No thanks")
        static let thanksMessage = NSLocalizedString("thanksMessage", comment: "Thanks!")
        
        static func insufficientCoinsMessage(coins: Int) -> String {
            let template = NSLocalizedString(
                "insufficientCoinsMessage",
                comment: "Sorry, but you don't have enough coins to buy this. Come back if you have collected %@ coins!")
            return String(format: template, "\(coins)")
        }
        static func confirmBuyQuestion(productName: String, coins: Int) -> String {
            let template = NSLocalizedString("confirmBuyQuestion", comment: "Do you want to buy \"%@\" for %@ coins?")
            return String(format: template, "\(productName)", "\(coins)")
        }
        static func buyConfimationMessage(productName: String) -> String {
            let template = NSLocalizedString("buyConfimationMessage", comment: "You bought a new %@!")
            return String(format: "\(template)", "\(productName)")
        }
    }
    
    struct Premium {
        static let featureWaitingTime = NSLocalizedString("featureWaitingTime", comment: "No more waiting time and purchase reminders!")
        static let featureTowerHeight = NSLocalizedString("featureTowerHeight", comment: "Build your personal tower as high as you like!")
        static let featureSupport = NSLocalizedString("featureSupport", comment: "Support the development of this and other games!")
        static let restoreTitle = NSLocalizedString("restoreTitle", comment: "Restore")
        static let buyTitle = NSLocalizedString("buyTitle", comment: "BUY")
        static let buyingLabel = NSLocalizedString("buyingLabel", comment: "buying...")
        static let loadingPriceLabel = NSLocalizedString("loadingPriceLabel", comment: "loading price...")
        static let restoredTitle = NSLocalizedString("restoredTitle", comment: "Restored")
        static let errorTitle = NSLocalizedString("errorTitle", comment: "Error")
        static let restoredMessage = NSLocalizedString("restoredMessage", comment: "Restore was successfull.")
        static let errorMessage = NSLocalizedString("errorMessage", comment: "Error restoring premium, please try again.")
        static let purchaseConfirmationTitle = NSLocalizedString("purchaseConfirmationTitle", comment: "Sold")
        static let purchaseConfirmationMessage = NSLocalizedString("purchaseConfirmationMessage", comment: "Thank you for buying premium!")
    }
}
