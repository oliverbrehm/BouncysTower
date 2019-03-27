//
//  LevelConfiguration.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 01.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

protocol LevelConfiguration {
    var backgroundColor: SKColor { get }
    var amientParticleName: String? { get }
    var topPlatformY: CGFloat { get }
    var platformMinFactor: CGFloat { get }
    var platformMaxFactor: CGFloat { get }
    var isLastPlatform: Bool { get }
    var isFinished: Bool { get }
    var platformYDistance: CGFloat { get }
    var numberOfPlatforms: Int { get }
    var levelSpeed: CGFloat { get }
    var gameSpeed: CGFloat { get }
    var firstPlatformOffset: CGFloat { get }
    var multiplicator: Int { get }
}
