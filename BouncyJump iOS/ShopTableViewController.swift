//
//  ShopTableViewController.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 26.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

class ShopTableViewController: UITableViewController {

    
    @IBOutlet weak var costExtraLife: UILabel!
    @IBOutlet weak var costBrickStandard: UILabel!
    @IBOutlet weak var costBrickDiamond: UILabel!
    
    override func didMove(toParent parent: UIViewController?) {
        costExtraLife.text = "x \(ResourceManager.costExtraLife)"
        costBrickStandard.text = "x \(Brick.standard.cost)"
        costBrickDiamond.text = "x \(Brick.diamond.cost)"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row) {
        case 0:
            Config.standard.buyExtralife()
            update()
        case 1:
            Config.standard.buyBrick(Brick.standard)
            update()
        case 2:
            Config.standard.buyBrick(Brick.diamond)
            update()
        default: break
        }
    }
    
    private func update() {
        if let shopVC = self.parent as? ShopViewController {
            shopVC.updateInventory()
        }
    }
}
