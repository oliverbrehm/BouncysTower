//
//  Score.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 25.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

class Score {
    static let standard = Score()
    
    enum UserDefaultsKeys: String {
        case scores = "SCORES"
        case highestJump = "HIGHEST_JUMP"
        case towerHeight = "TOWER_HEIGHT"
        case longestCombo = "LONGEST_COMBO"
    }
    
    private static let maxScores = 10
    
    private(set) var scores = [Int]() {
        didSet {
            scores.sort { (a, b) -> Bool in
                a > b
            }
            while scores.count > Score.maxScores {
                scores.removeLast()
            }
            UserDefaults.standard.set(scores, forKey: UserDefaultsKeys.scores.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var highestJump: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.highestJump.rawValue)
        }
        
        set {
            if newValue > highestJump {
                UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.highestJump.rawValue)
                UserDefaults.standard.synchronize()
                GameCenterManager.standard.uploadHighestJump(highestJump: newValue)
            }
        }
    }
    
    var towerHeight: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.towerHeight.rawValue)
        }
        
        set {
            if newValue > towerHeight {
                UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.towerHeight.rawValue)
                UserDefaults.standard.synchronize()
                GameCenterManager.standard.uploadTowerHeight(towerHeight: newValue)
            }
        }
    }
    
    var longestCombo: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.longestCombo.rawValue)
        }
        
        set {
            if newValue > longestCombo {
                UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.longestCombo.rawValue)
                UserDefaults.standard.synchronize()
                GameCenterManager.standard.uploadLongestCombo(longestCombo: newValue)
            }
        }
    }
    
    private(set) var mostRecentRank: Int?
    
    func unsetRecentRank() {
        mostRecentRank = nil
    }
    
    init() {
        if let scores = UserDefaults.standard.array(forKey: UserDefaultsKeys.scores.rawValue) as? [Int] {
            self.scores = scores
        }
    }
    
    func reset() {
        UserDefaults.standard.setValue(0, forKey: UserDefaultsKeys.highestJump.rawValue)
        UserDefaults.standard.setValue(0, forKey: UserDefaultsKeys.longestCombo.rawValue)
        UserDefaults.standard.setValue([], forKey: UserDefaultsKeys.scores.rawValue)
        UserDefaults.standard.setValue(0, forKey: UserDefaultsKeys.towerHeight.rawValue)
        UserDefaults.standard.synchronize()
        
        unsetRecentRank()
    }
    
    // adds the score and returns the rank (0-based)
    func addScore(_ score: Int) -> Int? {
        self.scores.append(score)
        mostRecentRank = self.scores.firstIndex(of: score)
        
        if mostRecentRank == 0 {
            GameCenterManager.standard.uploadHighscore(highscore: score)
        }
        
        return mostRecentRank
    }
}
