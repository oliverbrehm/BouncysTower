//
//  ShopProduct.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 14.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

enum ProductType: Equatable {
    case buyPremium
    case extalife
    case brick(Brick)
}

struct ShopProduct {
    let imageName: String
    let title: String
    let description: String
    let cost: Int
    let type: ProductType
    let color: SKColor?
}
