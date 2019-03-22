//
//  Score.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 25.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

class Score {
    static let standard = Score()
    
    private static let scoresKey = "SCORES"
    private static let maxScores = 10
    
    private(set) var scores = [Int]() {
        didSet {
            scores.sort { (a, b) -> Bool in
                a > b
            }
            while(scores.count > Score.maxScores) {
                scores.removeLast()
            }
            UserDefaults.standard.set(scores, forKey: Score.scoresKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private(set) var mostRecentRank: Int?
    
    func unsetRecentRank() {
        mostRecentRank = nil
    }
    
    init() {
        if let scores = UserDefaults.standard.array(forKey: Score.scoresKey) as? [Int] {
            self.scores = scores
        }
    }
    
    // adds the score and returns the rank (0-based)
    func addScore(_ score: Int) -> Int? {
        self.scores.append(score)
        mostRecentRank = self.scores.firstIndex(of: score)
        return mostRecentRank
    }
}
