//
//  ShopViewController.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    var delegate: ShopDelegate?

    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var extralivesLabel: UILabel!
    
    @IBAction func backTouched(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        self.updateInventory()
    }
    
    func updateInventory() {
        self.coinsLabel.text = "x \(Config.standard.coins)"
        self.extralivesLabel.text = "x \(Config.standard.extraLives)"
        
        self.delegate?.purchaseDone()
    }
}
