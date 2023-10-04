//
//  NodeCategories.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation

// swiftlint:disable colon
class NodeCategories {
    static let player                : UInt32 = 0x1 << 1
    static let platform              : UInt32 = 0x1 << 2
    static let platformDeactivated   : UInt32 = 0x1 << 3
    static let wall                  : UInt32 = 0x1 << 4
    static let particle              : UInt32 = 0x1 << 5
    static let consumable            : UInt32 = 0x1 << 6
}

// swiftlint:enable colon
