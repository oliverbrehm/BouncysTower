//
//  Tutorial.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

// TODO REMOVE
/*
class Tutorial: Game {
    enum TutorialState {
        case t0Start
        case t1Move
        case t2Jump
        case t3HighJump
        case t4Platforms
        case t5WallJumps
        case t6HighPlatformJumps
        case t7Combos
    }
    
    let infoBox = InfoBox()
    var tutorialState = TutorialState.t0Start
    
    override func setup() {
        self.camera?.addChild(self.infoBox)
        self.world.currentLevel?.spawnBackground(above: 2500.0)
        self.world.currentLevel?.spawnWallTiles(above: 2500.0)
        
        //self.player.jumpReadyTime = 0.35
    }
    
    override func resetGame() {
        super.resetGame()
        self.tutorialStart()
    }
    
    override func updateGame(_ dt: TimeInterval) {
        if(self.state.runningState == .started || self.state.runningState == .running) {
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
        if(self.world.coinManager.numberOfCoins() == 0) {
            switch self.tutorialState {
            case .t1Move:
                self.tutorial2Jump()
                
            case .t2Jump:
                self.tutorial3HighJump()
                
            case .t3HighJump:
                self.tutorial4Platforms()
                
            case .t4Platforms:
                self.tutorial5WallJumps()
                
            case .t5WallJumps:
                self.tutorial6HighPlatformJumps()

            case .t6HighPlatformJumps:
                self.tutorial7Combos()
                
            case .t7Combos:
                self.finishTutorial()
                
            default: break
            }
        }
    }
    
    private func tutorialStart() {
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run {
                self.tutorial1Move()
            }
        ]))
    }
    
    private func tutorial1Move() {
        self.state.allowJump = false
        self.tutorialState = .t1Move

        self.infoBox.clear()
        self.infoBox.addLine(text: "Hi! Let's learn how to play.")
            self.infoBox.addLine(text: "Hold your finger on the screen and move it to the left or right.")
        self.infoBox.addLine(text: "Start by collecting all the coins on the floor.")
        self.infoBox.setImage(name: "leftright", height: 65.0)
        self.showInfo(completion: {
            self.world.spawnFloor()
            
            let coinY = self.world.absoluteZero() + 25.0
            self.world.coinManager.spawnHorizontalLine(origin: CGPoint(x: 0.0, y: coinY), width: self.world.width - 150.0, n: 10)
        })
    }
    
    private func tutorial2Jump() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "Great! Now try jumping:")
        self.infoBox.addLine(text: "When you keep your finger on the screen and roll around,")
        self.infoBox.addLine(text: "Bouncy will soon turn red.")
        self.infoBox.addLine(text: "That means he's ready to jump, just release your finger!")
        self.infoBox.setImage(name: "leftright", height: 65.0)
        
        self.showInfo(completion: {
            self.infoBox.clear()
            self.infoBox.addLine(text: "There's no need to swipe up, Bouncy will jump on his own")
            self.infoBox.addLine(text: "if you release you touch.")
            self.infoBox.addLine(text: "You only move your finger left and right so he can roll on")
            self.infoBox.addLine(text: "the platforms.")
            self.infoBox.setImage(name: "noup", height: 65.0)
            
            self.showInfo(completion: {
                self.tutorialState = .t2Jump
                self.state.allowJump = true
                
                self.world.coinManager.spawnHorizontalLine(
                    origin: CGPoint(x: 0.0, y: self.world.absoluteZero() + 125.0),
                    width: self.world.width - 150.0, n: 10)
                self.world.coinManager.spawnHorizontalLine(
                    origin: CGPoint(x: 20.0, y: self.world.absoluteZero() + 150.0),
                    width: self.world.width - 150.0, n: 10)
                self.world.coinManager.spawnHorizontalLine(
                    origin: CGPoint(x: 0.0, y: self.world.absoluteZero() + 175.0),
                    width: self.world.width - 150.0, n: 10)
            })
        })
    }
    
    private func tutorial3HighJump() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "Noticed that you jump higher when rolling?")
        self.infoBox.addLine(text: "Reach these next coins by rolling fast on the ground")
        self.infoBox.addLine(text: "and then releasing your touch.")
        self.infoBox.setImage(name: "leftright", height: 65.0)
        
        self.showInfo(completion: {
            self.tutorialState = .t3HighJump
            
            self.world.coinManager.spawnSquare(origin: CGPoint(x: -180.0, y: self.world.absoluteZero() + 280.0), distanceBetween: 8.0, nSide: 2)
            self.world.coinManager.spawnSquare(origin: CGPoint(x: 180.0, y: self.world.absoluteZero() + 280.0), distanceBetween: 8.0, nSide: 2)
        })
    }
    
    private func tutorial4Platforms() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "Great!")
        self.infoBox.addLine(text: "Next jump on the platforms to collect the coins on top.")
        self.showInfo(completion: {
            self.tutorialState = .t4Platforms
            //self.player.jumpReadyTime = 0.25
            
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
            self.tutorialState = .t5WallJumps
            self.world.currentLevel!.removeAllPlatforms()
            self.world.currentLevel!.reset()

            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 2.0), // player falls to the floor
                SKAction.run {
                    self.world.coinManager.spawnSquare(
                        origin: CGPoint(x: -180.0, y: self.world.absoluteZero() + 300.0),
                        distanceBetween: 6.0, nSide: 3)
                    self.world.coinManager.spawnSquare(
                        origin: CGPoint(x: 180.0, y: self.world.absoluteZero() + 300.0),
                        distanceBetween: 6.0, nSide: 3)
                    
                    self.world.coinManager.spawnSquare(
                        origin: CGPoint(x: -60.0, y: self.world.absoluteZero() + 420.0),
                        distanceBetween: 6.0, nSide: 3)
                    self.world.coinManager.spawnSquare(
                        origin: CGPoint(x: 60.0, y: self.world.absoluteZero() + 420.0),
                        distanceBetween: 6.0, nSide: 3)
                }
            ]))
        })
    }
    
    private func tutorial6HighPlatformJumps() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "Wow that was some crazy jumping!")
        self.infoBox.addLine(text: "You can roll left and right on the platforms")
        self.infoBox.addLine(text: "to gain speed and jump higher.")
        self.showInfo(completion: {
            self.tutorialState = .t6HighPlatformJumps
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
    
    private func tutorial7Combos() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "OK! One last thing:")
        self.infoBox.addLine(text: "You can get combos and way more points if you")
        self.infoBox.addLine(text: "use wall jumps and just let Bouncy roll and bounce.")
        self.showInfo(completion: {
            self.tutorialState = .t7Combos
            self.world.currentLevel!.removeAllPlatforms()
            self.world.currentLevel!.reset()
            
            self.infoBox.clear()
            self.infoBox.addLine(text: "Don't be scared, this takes a while to master!")
            self.infoBox.setImage(name: "combo", height: 250.0)
            self.showInfo {
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 1.6), // player falls to the floor
                    SKAction.run {
                        self.world.spawnPlatform(numberOfCoins: 0, yDistance: 200.0)
                        self.world.spawnPlatform(numberOfCoins: 0, yDistance: 280.0)
                        self.world.spawnPlatform(numberOfCoins: 0, yDistance: 280.0)
                        self.world.spawnPlatform(numberOfCoins: 0, yDistance: 280.0)
                        self.world.spawnPlatform(numberOfCoins: 0, yDistance: 280.0)
                        self.world.spawnPlatform(numberOfCoins: 0, yDistance: 280.0)
                        self.world.spawnPlatform(numberOfCoins: 0, yDistance: 280.0)
                        self.world.spawnPlatform(numberOfCoins: 0, yDistance: 280.0)
                        self.world.spawnPlatform(numberOfCoins: 0, yDistance: 280.0)
                        self.world.spawnPlatform(numberOfCoins: 8, yDistance: 280.0)
                    }
                ]))
            }
        })
    }
    
    private func finishTutorial() {
        self.infoBox.clear()
        self.infoBox.addLine(text: "Awesome, that's it for now!")
        self.infoBox.addLine(text: "The tower is waiting for you.")
        self.infoBox.addLine(text: "Use your jumping skills to get as far up as possible!")
        self.showInfo(completion: {
            self.gameViewController?.showGame()
        })
    }
}
*/
