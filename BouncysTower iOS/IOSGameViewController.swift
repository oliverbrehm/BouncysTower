//
//  GameViewController.swift
//  BouncysTower iOS
//
//  Created by Oliver Brehm on 02.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class IOSGameViewController: GameViewController {
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
