//
//  GameCenterManager.swift
//  BouncysTower iOS
//
//  Created by Oliver Brehm on 02.06.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import GameKit

class GameCenterManager: NSObject, GKGameCenterControllerDelegate {
    
    private enum Leaderboard: String {
        case highscore = "brehm.oliver.BouncysTower.highscore"
        case highestJump = "brehm.oliver.BouncysTower.highestjump"
        case towerHeight = "brehm.oliver.BouncysTower.towerheight"
        case longestCombo = "brehm.oliver.BouncysTower.longestcombo"
        
        var identifier: String {
            return rawValue
        }
    }
    
    static var standard = GameCenterManager()
    
    var presentingViewController: UIViewController?
    
    private let gameCenterViewController = GKGameCenterViewController(
        leaderboardID: Leaderboard.highscore.identifier,
        playerScope: .global,
        timeScope: .allTime
    )

    override init() {
        super.init()
        
        gameCenterViewController.gameCenterDelegate = self
    }
    
    func authenticate(completion: @escaping (Bool) -> Void) {
        GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
            if GKLocalPlayer.local.isAuthenticated {
                print("Authentification with Game Center ok.")
                completion(true)
            } else if let vc = gcAuthVC {
                self.presentingViewController?.present(vc, animated: true) {
                    completion(true)
                }
            } else {
                print("Error authentication to GameCenter: " +
                    "\(error?.localizedDescription ?? "unknown error")")
                completion(false)
            }
        }
    }
    
    func showLeaderboard() {
        if let vc = presentingViewController {
            vc.show(gameCenterViewController, sender: self)
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
    // MARK: - upload leader boards
    private func uploadScore(leaderboard: Leaderboard, score: Int, completion: ((Bool) -> Void)?) {
        guard GKLocalPlayer.local.isAuthenticated else {
            print("uploadScore: GameCenter not authenticated")
            completion?(false)
            return
        }

        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboard.identifier]) { (error: Error?) in
            completion?(error == nil)
        }
    }
    
    func uploadHighscore(highscore: Int, completion: ((Bool) -> Void)? = nil) {
        uploadScore(leaderboard: .highscore, score: highscore, completion: completion)
    }
    
    func uploadHighestJump(highestJump: Int, completion: ((Bool) -> Void)? = nil) {
        uploadScore(leaderboard: .highestJump, score: highestJump, completion: completion)
    }
    
    func uploadTowerHeight(towerHeight: Int, completion: ((Bool) -> Void)? = nil) {
        uploadScore(leaderboard: .towerHeight, score: towerHeight, completion: completion)
    }
    
    func uploadLongestCombo(longestCombo: Int, completion: ((Bool) -> Void)? = nil) {
        uploadScore(leaderboard: .longestCombo, score: longestCombo, completion: completion)
    }
}
