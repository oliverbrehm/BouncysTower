//
//  Tutorial.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Tutorial: Game {
    enum TutorialState {
        case T0Start
        case T1Move
        case T2Jump
        case T3HighJump
        case T4Platforms
        case T5WallJumps
        case T6HighPlatformJumps
    }
    
    let infoBox = InfoBox()
    var tutorialState = TutorialState.T0Start
    
    override func setup() {
        self.camera?.addChild(self.infoBox)
        self.infoBox.position = CGPoint(x: 0.0, y: 0.25 * self.world.height)
        self.infoBox.setup(size: CGSize(width: 0.75 * self.world.width, height: 0.35 * self.world.height))
        self.world.currentLevel?.spawnBackground(beneath: 2500.0)
        self.world.currentLevel?.spawnWallTiles(beneath: 2500.0)
    }
    
    override func resetGame() {
        super.resetGame()
        self.tutorialStart()
    }
    
    override func updateGame(_ dt: TimeInterval) {
        if(self.State.runningState == .started || self.State.runningState == .running)
        {
            self.cameraNode.updateInTutorial(player: self.player, world: self.world)
        }
    }
    
    private func showInfo(completion: @escaping () -> Void) {
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.4),
            SKAction.run {
                self.pause()
                self.infoBox.show(completion: {
                    self.resume()
                    completion()
                })
            }
        ]))
    }
    
    override func hitCoin(coin: Coin) {
        if(self.world.numberOfCoins() == 0) {
            switch self.tutorialState {
            case .T1Move:
                self.tutorial2Jump()
                break
                
            case .T2Jump:
                self.tutorial3HighJump()
                break
                
            case .T3HighJump:
                self.tutorial4Platforms()
                break
                
            case .T4Platforms:
                self.tutorial5WallJumps()
                break
                
            case .T5WallJumps:
                self.tutorial6HighPlatformJumps()
                break

            case .T6HighPlatformJumps:
                self.finishTutorial()
                break
                
            default: break
            }
        }
    }
    
    private func tutorialStart() {
        self.world.currentLevel!.spawnWallTiles(beneath: 5 * self.world.height)
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run {
                self.tutorial1Move()
            }
        ]))
    }
    
    private func tutorial1Move() {
        self.State.allowJump = false
        self.tutorialState = .T1Move

        self.infoBox.clear()
        self.infoBox.addLine(text: "Hi! Let's learn how to play.")
        self.infoBox.addLine(text: "Touch and move you finger to the left or right to move.")
        self.infoBox.addLine(text: "Start by collecting all the coins on the floor.")
        self.showInfo(completion: {
            self.world.spawnFloor()
            
            let coinY = self.world.absoluteZero() + 25.0
            self.world.spawnCoin(position: CGPoint(x: -200.0, y: coinY))
            self.world.spawnCoin(position: CGPoint(x: -150.0, y: coinY))
            self.world.spawnCoin(position: CGPoint(x: -100.0, y: coinY))
            self.world.spawnCoin(position: CGPoint(x: -50.0, y: coinY))

            self.world.spawnCoin(position: CGPoint(x: 50.0, y: coinY))
            self.world.spawnCoin(position: CGPoint(x: 100.0, y: coinY))
            self.world.spawnCoin(position: CGPoint(x: 150.0, y: coinY))
            self.world.spawnCoin(position: CGPoint(x: 200.0, y: coinY))
        })
    }
    
    private func tutorial2Jump() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "Great! Now try jumping so you can climb to the top of the tower.")
        self.infoBox.addLine(text: "Jump by releasing your finger.")
        self.infoBox.addLine(text: "You can still move left or right while in the air!")
        self.showInfo(completion: {
            self.tutorialState = .T2Jump
            self.State.allowJump = true
            
            let y = self.world.absoluteZero() + 150.0
            let coinPositions = [
                CGPoint(x: -200.0, y: y),
                CGPoint(x: 0.0, y: y),
                CGPoint(x: 200.0, y: y)
            ]
            
            for p in coinPositions {
                self.world.spawnCoin(position: p)
            }
        })
    }
    
    private func tutorial3HighJump() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "Noticed that you jump higher when rolling?")
        self.infoBox.addLine(text: "Reach these next coins by rolling fast on the ground")
        self.infoBox.addLine(text: "and then releasing your touch.")
        self.showInfo(completion: {
            self.tutorialState = .T3HighJump
            
            self.world.spawnCoin(position: CGPoint(x: -200.0, y: self.world.absoluteZero() + 240.0))
            self.world.spawnCoin(position: CGPoint(x: -220.0, y: self.world.absoluteZero() + 240.0))
            self.world.spawnCoin(position: CGPoint(x: -200.0, y: self.world.absoluteZero() + 260.0))
            self.world.spawnCoin(position: CGPoint(x: -220.0, y: self.world.absoluteZero() + 260.0))
            
            
            self.world.spawnCoin(position: CGPoint(x: 200.0, y: self.world.absoluteZero() + 240.0))
            self.world.spawnCoin(position: CGPoint(x: 220.0, y: self.world.absoluteZero() + 240.0))
            self.world.spawnCoin(position: CGPoint(x: 200.0, y: self.world.absoluteZero() + 260.0))
            self.world.spawnCoin(position: CGPoint(x: 220.0, y: self.world.absoluteZero() + 260.0))
        })
    }
    
    private func tutorial4Platforms() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "Wow that was some crazy jumping!")
        self.infoBox.addLine(text: "Next jump on the platforms to collect all coins.")
        self.showInfo(completion: {
            self.tutorialState = .T4Platforms
            
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0), // player falls to the floor
                SKAction.run {
                    for _ in 0..<9 {
                        self.world.spawnPlatform(numberOfCoins: 0)
                    }
                    self.world.spawnPlatform(numberOfCoins: 8)
                }
            ]))
        })
        
    }
    
    private func tutorial5WallJumps() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "Nicely done!")
        self.infoBox.addLine(text: "You can jump even higher if you jump against the wall.")
        self.infoBox.addLine(text: "Can you reach the coins all the way up there?")
        self.showInfo(completion: {
            self.tutorialState = .T5WallJumps
            self.world.currentLevel!.removeAllPlatforms()

            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 2.0), // player falls to the floor
                SKAction.run {
                    let coinPositions = [
                        CGPoint(x: -80.0, y: self.world.absoluteZero() + 150.0),
                        CGPoint(x: -140.0, y: self.world.absoluteZero() + 225.0),
                        CGPoint(x: -200.0, y: self.world.absoluteZero() + 300.0),
                        CGPoint(x: -140.0, y: self.world.absoluteZero() + 375.0),
                        CGPoint(x: -80.0, y: self.world.absoluteZero() + 450.0),
                        
                        CGPoint(x: 80.0, y: self.world.absoluteZero() + 150.0),
                        CGPoint(x: 140.0, y: self.world.absoluteZero() + 225.0),
                        CGPoint(x: 200.0, y: self.world.absoluteZero() + 300.0),
                        CGPoint(x: 140.0, y: self.world.absoluteZero() + 375.0),
                        CGPoint(x: 80.0, y: self.world.absoluteZero() + 450.0),
                        ]
                    
                    for p in coinPositions {
                        self.world.spawnCoin(position: p)
                    }
                }
            ]))
        })
    }
    
    private func tutorial6HighPlatformJumps() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "You can roll left and right on the platforms")
        self.infoBox.addLine(text: "to gain speed and jump higher.")
        self.infoBox.addLine(text: "Try it!")
        self.showInfo(completion: {
            self.tutorialState = .T6HighPlatformJumps
            self.world.currentLevel!.reset()

            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5), // player falls to the floor
                SKAction.run {
                    self.world.spawnPlatform(numberOfCoins: 0, yDistance: 110.0)
                    self.world.spawnPlatform(numberOfCoins: 0, yDistance: 110.0)
                    self.world.spawnPlatform(numberOfCoins: 0, yDistance: 220.0)
                    self.world.spawnPlatform(numberOfCoins: 0, yDistance: 110.0)
                    self.world.spawnPlatform(numberOfCoins: 0, yDistance: 110.0)
                    self.world.spawnPlatform(numberOfCoins: 0, yDistance: 300.0)
                    self.world.spawnPlatform(numberOfCoins: 0, yDistance: 110.0)
                    self.world.spawnPlatform(numberOfCoins: 8, yDistance: 110.0)
                }
            ]))
        })
    }
    
    private func finishTutorial() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "Awesome, that's it for now!")
        self.infoBox.addLine(text: "The tower is waiting for you.")
        self.infoBox.addLine(text: "Use your jumping skills to get as far up as possible!")
        self.showInfo(completion: {
            Config.standard.tutorialShown = true
            self.GameViewController?.showGame()
        })
    }
}
