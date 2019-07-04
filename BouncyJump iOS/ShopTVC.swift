//
//  ShopTVCTableViewController.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 14.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

class ShopTVC: UITableViewController {
    
    private var products: [ShopProduct] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        makeProducts()
        tableView.reloadData()
    }
    
    private func makeProducts() {
        products = []
        
        if !InAppPurchaseManager.shared.premiumPurchased {
            let buyPremium = ShopProduct(imageName: "player", title: "Buy premium",
                                         description: "For no more reminders to buy and a good concience",
                                         cost: 0, type: .buyPremium, color: nil)
            products.append(buyPremium)
        }
        
        let extralife = ShopProduct(imageName: "extralife", title: "Extra life",
                                description: "Saves you once from falling down",
                                cost: ResourceManager.costExtraLife, type: .extalife, color: nil)
        products.append(extralife)
        
        for brick in Brick.allCases {
            let brickProduct = ShopProduct(imageName: brick.textureName, title: brick.name,
                                       description: brick.description,
                                       cost: brick.cost, type: .brick(brick), color: brick.color)
            products.append(brickProduct)
        }
    }
    
    private func update() {
        if let shopVC = self.parent as? ShopViewController {
            shopVC.updateInventory()
        }
    }
    
    private func showNotEnoughCoinsAlert(for product: ShopProduct) {
        let message = "Sorry, but you don't have enough coins to buy this. Come back if you have collected \(product.cost) coins!"
        let alert = UIAlertController(title: "Not enough coins", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    private func askToBuy(product: ShopProduct, didBuyHandler: @escaping () -> Void) {
        let question = "Do you want to buy \"\(product.title)\" for \(product.cost) coins?"
        let alert = UIAlertController(title: "Buy", message: question, preferredStyle: .alert)
        
        let buyAction = UIAlertAction(title: "Buy", style: .destructive) { (_) in
            didBuyHandler()
            self.confirmPurchase(for: product)
        }
        let cancelAction = UIAlertAction(title: "No thanks", style: .cancel)
        alert.addAction(buyAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    private func confirmPurchase(for product: ShopProduct) {
        let message = "You bought a new \(product.title)!"
        let alert = UIAlertController(title: "Thanks!", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        let productImage = UIImageView(frame: CGRect(x: 5, y: 5, width: 35, height: 35))
        productImage.image = UIImage(named: product.imageName)
        productImage.contentMode = .scaleAspectFit
        alert.view.addSubview(productImage)
        
        self.present(alert, animated: true)
        self.update()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductCell {
            let product = products[indexPath.row]
            cell.product = product
            
            cell.productTitleLabel.text = product.title
            cell.productDescriptionLabel.text = product.description
            
            let productImage = UIImage(named: product.imageName)
            
            if let productColor = product.color {
                cell.productImageView.backgroundColor = productColor
            } else {
                cell.productImageView.backgroundColor = UIColor.clear
            }
            
            cell.productImageView.image = productImage
            
            if(product.cost > 0) {
                cell.productCostLabel.text = "x \(product.cost)"
                cell.productCostLabel.isHidden = false
                cell.coinImageView.isHidden = false
            } else {
                cell.productCostLabel.isHidden = true
                cell.coinImageView.isHidden = true
            }
            
            return cell
        }

        return UITableViewCell(style: .default, reuseIdentifier: "")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        
        if(Config.standard.coins < product.cost) {
            self.showNotEnoughCoinsAlert(for: product)
            return
        }
        
        switch product.type {
        case .buyPremium:
            if let shop = self.parent as? ShopViewController {
                AdvertisingController.shared.present(in: shop)
            }
        case .extalife:
            self.askToBuy(product: product) {
                Config.standard.buyExtralife()
            }
        case .brick(let brick):
            self.askToBuy(product: product) {
                Config.standard.buyBrick(brick)
            }
        }
    }
}
