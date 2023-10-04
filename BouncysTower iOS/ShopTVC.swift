//
//  ShopTVCTableViewController.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 14.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

class ShopTVC: UITableViewController {
    
    private var products: [ShopProduct] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadData()
    }
    
    func reloadData() {
        makeProducts()
        tableView.reloadData()
    }
    
    private func makeProducts() {
        products = []
        
        if !InAppPurchaseManager.shared.premiumPurchased {
            let buyPremium = ShopProduct(imageName: "player", title: Strings.Shop.buyPremiumTitle,
                                         description: Strings.Shop.buyPremiumDescription,
                                         cost: 0, type: .buyPremium)
            products.append(buyPremium)
        }
        
        let extralife = ShopProduct(imageName: "extralife", title: Strings.Shop.extralifeTitle,
                                description: Strings.Shop.extralifeDescription,
                                cost: ResourceManager.costExtraLife, type: .extalife)
        products.append(extralife)
        
        for brick in Brick.allCases.sorted(by: { $0.cost < $1.cost }) {
            let brickProduct = ShopProduct(imageName: brick.textureName, title: brick.name,
                                       description: brick.description,
                                       cost: brick.cost, type: .brick(brick))
            products.append(brickProduct)
        }
    }
    
    private func update() {
        if let shopVC = self.parent as? ShopViewController {
            shopVC.update()
        }
    }
    
    private func showNotEnoughCoinsAlert(for product: ShopProduct) {
        let alert = UIAlertController(
            title: Strings.Shop.insufficientCoinsTitle,
            message: Strings.Shop.insufficientCoinsMessage(coins: product.cost),
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    private func askToBuy(product: ShopProduct, didBuyHandler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: Strings.Shop.confirmBuyTitle,
            message: Strings.Shop.confirmBuyQuestion(productName: product.title, coins: product.cost),
            preferredStyle: .alert)
        
        let buyAction = UIAlertAction(title: Strings.Shop.confirmBuyTitle, style: .destructive) { (_) in
            didBuyHandler()
            self.confirmPurchase(for: product)
        }
        let cancelAction = UIAlertAction(title: Strings.Shop.noThanksMessage, style: .cancel)
        alert.addAction(buyAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    private func confirmPurchase(for product: ShopProduct) {
        let alert = UIAlertController(
            title: Strings.Shop.confirmBuyTitle,
            message: Strings.Shop.buyConfimationMessage(productName: product.title),
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
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
            cell.productImageView.image = UIImage(named: product.imageName)
            
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

        return UITableViewCell()
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
