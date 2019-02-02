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
        case T4WallJumps
        case T5Platforms
        case T6HighPlatformJumps
    }
    
    let infoBox = InfoBox()
    var state = State.T0Start
    
    override func Setup() {
        self.camera?.addChild(self.infoBox)
        self.infoBox.position = CGPoint(x: 0.0, y: 0.25 * self.world.Height)
        self.infoBox.size = CGSize(width: 0.65 * self.world.Width, height: 0.35 * self.world.Height)
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
    
    private func ShowInfo(_ text: String, completion: @escaping () -> Void) {
        self.Pause()
        self.infoBox.Show(text: text, completion: {
            self.Resume()
            completion()
        })
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
                    self.tutorial4WallJumps()
                break
                
            case .T4WallJumps:
                self.tutorial5Platforms()
                break
                
            case .T5Platforms:
                    self.tutorial6HighPlatformJumps()
            
            case .T6HighPlatformJumps:
                self.finishTutorial()
                break
                
            default: break
            }
        }
    }
    
    private func tutorialStart() {
        self.world.SpawnWallTilesForLevel(self.world.CurrentLevel, beneath: 5 * self.world.Height)
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run {
                self.tutorial1Move()
            }
        ]))
    }
    
    private func tutorial1Move() {
        self.ShowInfo("Swipe to move. Collect coins.", completion: {
            self.state = .T1Move
            
            self.world.SpawnFloor(numberOfCoins: 8)
        })
    }
    
    private func tutorial2Jump() {
        self.ShowInfo("Jump.", completion: {
            self.state = .T2Jump
            
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
        self.ShowInfo("High jump.", completion: {
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
    
    private func tutorial4WallJumps() {
        self.ShowInfo("Wall jupms.", completion: {
            self.state = .T4WallJumps
            
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
        })
    }
    
    private func tutorial5Platforms() {
        self.ShowInfo("Platforms.", completion: {
            self.state = .T5Platforms
            
            // TODO
            self.world.SpawnCoin(position: CGPoint(x: 0.0, y: 100.0))
        })
    }
    
    private func tutorial6HighPlatformJumps() {
        self.ShowInfo("High platform jump", completion: {
            self.state = .T6HighPlatformJumps
            
            // TODO
            self.world.SpawnCoin(position: CGPoint(x: 0.0, y: 150.0))
        })
    }
    
    private func finishTutorial() {
        self.ShowInfo("Finished!", completion: {
            self.GameViewController?.ShowGame()
        })
    }
}
