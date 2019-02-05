//
//  Tutorial.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Tutorial: Game {
    enum State {
        case T0Start
        case T1Move
        case T2Jump
        case T3HighJump
        case T4Platforms
        case T5WallJumps
        case T6HighPlatformJumps
    }
    
    let infoBox = InfoBox()
    var state = State.T0Start
    
    override func Setup() {
        self.camera?.addChild(self.infoBox)
        self.infoBox.position = CGPoint(x: 0.0, y: 0.25 * self.world.Height)
        self.infoBox.Setup(size: CGSize(width: 0.75 * self.world.Width, height: 0.35 * self.world.Height))
    }
    
    override func ResetGame() {
        super.ResetGame()
        self.tutorialStart()
    }
    
    override func updateGame(_ dt: TimeInterval) {
        if(gameState == .Started || gameState == .Running)
        {
            self.cameraNode.UpdateTutorial(player: self.player, world: self.world)
        }
    }
    
    private func ShowInfo(completion: @escaping () -> Void) {
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.4),
            SKAction.run {
                self.Pause()
                self.infoBox.Show(completion: {
                    self.Resume()
                    completion()
                })
            }
        ]))
    }
    
    override func hitCoin(coin: Coin) {
        if(self.world.NumberOfCoins() == 0) {
            switch self.state {
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
        self.world.CurrentLevel!.SpawnWallTiles(beneath: 5 * self.world.Height)
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run {
                self.tutorial1Move()
            }
        ]))
    }
    
    private func tutorial1Move() {
        self.infoBox.Clear()
        self.infoBox.AddLine(text: "Hi! Let's learn how to play.")
        self.infoBox.AddLine(text: "Touch and move you finger to the left or right to move.")
        self.infoBox.AddLine(text: "Start by collecting all the coins on the floor.")
        self.ShowInfo(completion: {
            self.state = .T1Move
            self.allowJump = false
            
            self.world.SpawnFloor(numberOfCoins: 8)
        })
    }
    
    private func tutorial2Jump() {
        self.infoBox.Clear()
        self.infoBox.AddLine(text: "Great! Now try jumping so you can climb to the top of the tower.")
        self.infoBox.AddLine(text: "Jump by releasing your finger.")
        self.infoBox.AddLine(text: "You can still move left or right while in the air!")
        self.ShowInfo(completion: {
            self.state = .T2Jump
            self.allowJump = true
            
            let y = self.world.AbsoluteZero() + 150.0
            let coinPositions = [
                CGPoint(x: -200.0, y: y),
                CGPoint(x: 0.0, y: y),
                CGPoint(x: 200.0, y: y)
            ]
            
            for p in coinPositions {
                self.world.SpawnCoin(position: p)
            }
        })
    }
    
    private func tutorial3HighJump() {
        self.infoBox.Clear()
        self.infoBox.AddLine(text: "Noticed that you jump higher when rolling?")
        self.infoBox.AddLine(text: "Reach these next coins by rolling fast on the ground")
        self.infoBox.AddLine(text: "and then releasing your touch.")
        self.ShowInfo(completion: {
            self.state = .T3HighJump
            
            self.world.SpawnCoin(position: CGPoint(x: -200.0, y: self.world.AbsoluteZero() + 240.0))
            self.world.SpawnCoin(position: CGPoint(x: -220.0, y: self.world.AbsoluteZero() + 240.0))
            self.world.SpawnCoin(position: CGPoint(x: -200.0, y: self.world.AbsoluteZero() + 260.0))
            self.world.SpawnCoin(position: CGPoint(x: -220.0, y: self.world.AbsoluteZero() + 260.0))
            
            
            self.world.SpawnCoin(position: CGPoint(x: 200.0, y: self.world.AbsoluteZero() + 240.0))
            self.world.SpawnCoin(position: CGPoint(x: 220.0, y: self.world.AbsoluteZero() + 240.0))
            self.world.SpawnCoin(position: CGPoint(x: 200.0, y: self.world.AbsoluteZero() + 260.0))
            self.world.SpawnCoin(position: CGPoint(x: 220.0, y: self.world.AbsoluteZero() + 260.0))
        })
    }
    
    private func tutorial4Platforms() {
        self.infoBox.Clear()
        self.infoBox.AddLine(text: "Wow that was some crazy jumping!")
        self.infoBox.AddLine(text: "Next jump on the platforms to collect all coins.")
        self.ShowInfo(completion: {
            self.state = .T4Platforms
            
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0), // player falls to the floor
                SKAction.run {
                    for _ in 0..<9 {
                        self.world.SpawnPlatform(numberOfCoins: 0)
                    }
                    self.world.SpawnPlatform(numberOfCoins: 8)
                }
            ]))
        })
        
    }
    
    private func tutorial5WallJumps() {
        self.infoBox.Clear()
        self.infoBox.AddLine(text: "Nicely done!")
        self.infoBox.AddLine(text: "You can jump even higher if you jump against the wall.")
        self.infoBox.AddLine(text: "Can you reach the coins all the way up there?")
        self.ShowInfo(completion: {
            self.state = .T5WallJumps
            self.world.CurrentLevel!.RemoveAllPlatforms()

            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 2.0), // player falls to the floor
                SKAction.run {
                    let coinPositions = [
                        CGPoint(x: -80.0, y: self.world.AbsoluteZero() + 150.0),
                        CGPoint(x: -140.0, y: self.world.AbsoluteZero() + 225.0),
                        CGPoint(x: -200.0, y: self.world.AbsoluteZero() + 300.0),
                        CGPoint(x: -140.0, y: self.world.AbsoluteZero() + 375.0),
                        CGPoint(x: -80.0, y: self.world.AbsoluteZero() + 450.0),
                        
                        CGPoint(x: 80.0, y: self.world.AbsoluteZero() + 150.0),
                        CGPoint(x: 140.0, y: self.world.AbsoluteZero() + 225.0),
                        CGPoint(x: 200.0, y: self.world.AbsoluteZero() + 300.0),
                        CGPoint(x: 140.0, y: self.world.AbsoluteZero() + 375.0),
                        CGPoint(x: 80.0, y: self.world.AbsoluteZero() + 450.0),
                        ]
                    
                    for p in coinPositions {
                        self.world.SpawnCoin(position: p)
                    }
                }
            ]))
        })
    }
    
    private func tutorial6HighPlatformJumps() {
        self.infoBox.Clear()
        self.infoBox.AddLine(text: "You can roll left and right on the platforms")
        self.infoBox.AddLine(text: "to gain speed and jump higher.")
        self.infoBox.AddLine(text: "Try it!")
        self.ShowInfo(completion: {
            self.state = .T6HighPlatformJumps
            self.world.CurrentLevel!.Reset()

            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5), // player falls to the floor
                SKAction.run {
                    self.world.SpawnPlatform(numberOfCoins: 0, yDistance: 110.0)
                    self.world.SpawnPlatform(numberOfCoins: 0, yDistance: 110.0)
                    self.world.SpawnPlatform(numberOfCoins: 0, yDistance: 220.0)
                    self.world.SpawnPlatform(numberOfCoins: 0, yDistance: 110.0)
                    self.world.SpawnPlatform(numberOfCoins: 0, yDistance: 110.0)
                    self.world.SpawnPlatform(numberOfCoins: 0, yDistance: 300.0)
                    self.world.SpawnPlatform(numberOfCoins: 0, yDistance: 110.0)
                    self.world.SpawnPlatform(numberOfCoins: 8, yDistance: 110.0)
                }
            ]))
        })
    }
    
    private func finishTutorial() {
        self.infoBox.Clear()
        self.infoBox.AddLine(text: "Awesome, that's it for now!")
        self.infoBox.AddLine(text: "The tower is waiting for you.")
        self.infoBox.AddLine(text: "Use your jumping skills to get as far up as possible!")
        self.ShowInfo(completion: {
            Config.Default.TutorialShown = true
            self.GameViewController?.ShowGame()
        })
    }
}
