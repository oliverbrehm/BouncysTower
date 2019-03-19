//
//  Logger.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 19.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import Foundation

class Logger {
    static let standard = Logger()
    
    private let logPlayerState = false
    private let logPerfectJumpState = false
    
    func playerState(message: String) {
        if(logPlayerState) {
            print("Logger(PlayerState): \(message)")
        }
    }
    
    func perfectJumpState(message: String) {
        if(logPerfectJumpState) {
            print("Logger(PerfectJumpState): \(message)")
        }
    }
}
