//
//  NodeCategories.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation

class NodeCategories
{
    public static let Player                : UInt32 = 0x1 << 1
    public static let Platform              : UInt32 = 0x1 << 2
    public static let PlatformDeactivated   : UInt32 = 0x1 << 3
    public static let Wall                  : UInt32 = 0x1 << 4
    public static let Particle              : UInt32 = 0x1 << 5
}
