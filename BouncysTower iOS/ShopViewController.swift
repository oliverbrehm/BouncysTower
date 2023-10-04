//
//  ShopViewController.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 26.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    weak var delegate: ShopDelegate?
    
    weak var tableViewController: ShopTVC?

    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var extralivesLabel: UILabel!
    
    @IBAction func backTouched(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.update()
    }
    
    func update() {
        self.coinsLabel.text = "x \(Config.standard.coins)"
        self.extralivesLabel.text = "x \(Config.standard.extraLives)"
        
        if let shopTVC = tableViewController {
            shopTVC.reloadData()
        }
        
        self.delegate?.purchaseDone()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopTVC = segue.destination as? ShopTVC {
            self.tableViewController = shopTVC
        } else if let premiumVC = segue.destination as? PremiumViewController {
            premiumVC.closeDelegate = update
        }
    }
}
