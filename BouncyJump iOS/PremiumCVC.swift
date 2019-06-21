//
//  PremiumCVC.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 14.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

class PremiumCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellWidth: CGFloat = 200.0
    private let cellSpacing: CGFloat = 30.0
    
    private let featureList = [
        "No more waiting time and reminders!",
        "Build your personal tower as high as you like!",
        "Support the development of this game and other awesome games!"
    ]
    
    private enum PremiumSection: Int, CaseIterable {
        case features
        case buy
        case close
    }
    
    private func setupBuyCell(_ cell: BuyPremiumCell) {
        if paymentInProgress {
            cell.priceLabel.text = "buying..."
        } else if InAppPurchaseManager.shared.hasProduct, let price = InAppPurchaseManager.shared.premiumPriceLocalized {
            cell.priceLabel.text = price
        } else {
            cell.priceLabel.text = "loading price..."
            InAppPurchaseManager.shared.requestProduct { success in
                if success, InAppPurchaseManager.shared.hasProduct, let price = InAppPurchaseManager.shared.premiumPriceLocalized  {
                    cell.priceLabel.text = price
                    self.collectionView.reloadData()
                }
            }
        }
        cell.backgroundColor = UIColor(named: "cellBg") ?? UIColor.white
        cell.layer.cornerRadius = 8.0
    }
    
    private func setupCloseCell(_ cell: ClosePremiumCell) {
        if let countdownSeconds = closeCountdownSeconds {
            cell.startCountdown(seconds: countdownSeconds)
        } else {
            cell.backgroundColor = UIColor(named: "cellBg") ?? UIColor.white
        }
        cell.layer.cornerRadius = 8.0
    }
    
    private var closeCountdownSeconds: Int?
    private var paymentInProgress = false
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PremiumSection.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == PremiumSection.features.rawValue) {
            return featureList.count
        } else {
            return 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        
        switch(indexPath.section) {
        case PremiumSection.buy.rawValue:
            if let buyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "buyCell", for: indexPath) as? BuyPremiumCell {
                self.setupBuyCell(buyCell)
                return buyCell
            }
        case PremiumSection.close.rawValue:
            if let closeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "closePremiumCell", for: indexPath) as? ClosePremiumCell {
                self.setupCloseCell(closeCell)
                return closeCell
            }
        default:
            if let featureCell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCell", for: indexPath) as? PremiumFeatureCell {
                let description = self.featureList[indexPath.row]
                featureCell.featureDescriptionTextView.text = description
                featureCell.backgroundColor = UIColor(named: "cellBg") ?? UIColor.white
                featureCell.layer.cornerRadius = 8.0
                return featureCell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat
        switch indexPath.section {
        case PremiumSection.buy.rawValue:
            height = 120.0
        case PremiumSection.close.rawValue:
            height = 80.0
        default:
            height = 180.0
        }
        
        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if(section == PremiumSection.buy.rawValue || section == PremiumSection.close.rawValue) {
            let totalWidth = collectionView.frame.size.width
            let totalInset = totalWidth - cellWidth
            return UIEdgeInsets(top: 0.0, left: totalInset / 2.0, bottom: cellSpacing, right: totalInset / 2.0)
        }
        
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: cellSpacing, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return cellSpacing
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == PremiumSection.buy.rawValue) {
            showPurchaseAlert()
        } else if(indexPath.section == PremiumSection.close.rawValue) {
            self.tryDismissPremiumViewController(from: self.collectionView.cellForItem(at: indexPath) as? ClosePremiumCell)
        } else {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: PremiumSection.buy.rawValue), at: .top, animated: true)
        }
    }
    
    func setCountdown(seconds: Int) {
        self.closeCountdownSeconds = seconds
    }
    
    private func tryDismissPremiumViewController(from closePremiumCell: ClosePremiumCell?) {
        if(closePremiumCell != nil && closePremiumCell!.isReadyToClose) {
            if let premiumVC = self.parent as? PremiumViewController {
                premiumVC.dismiss(animated: true)
                AdvertisingController.standard.dismiss()
            }
        }
    }
    
    private func showPurchaseAlert() {
        paymentInProgress = true
        collectionView.reloadData()
        
        InAppPurchaseManager.shared.purchase { success in
            if success {
                let alert = UIAlertController(title: "Sold", message: "Thank you for buying premium!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.dismiss(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Error buying premium, please try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.collectionView.reloadData()
                }
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
            
            self.paymentInProgress = false
            self.collectionView.reloadData()
        }
    }
}
