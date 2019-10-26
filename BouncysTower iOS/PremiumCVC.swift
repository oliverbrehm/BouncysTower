//
//  PremiumCVC.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 14.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

class PremiumCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellWidth: CGFloat = 200.0
    private let cellSpacing: CGFloat = 30.0
    
    private let featureList = [
        Strings.Premium.featureWaitingTime,
        Strings.Premium.featureTowerHeight,
        Strings.Premium.featureSupport
    ]
    
    private enum PremiumSection: Int, CaseIterable {
        case features
        case buy
        case close
    }
    
    private func setupBuyCell(_ cell: BuyPremiumCell, restore: Bool) {
        cell.layer.cornerRadius = 8.0
        cell.isUserInteractionEnabled = false
        cell.backgroundColor = UIColor.darkGray
        cell.titleLabel.text = restore ? Strings.Premium.restoreTitle : Strings.Premium.buyTitle
        
        if paymentInProgress {
            cell.priceLabel.text = Strings.Premium.buyingLabel
            cell.isUserInteractionEnabled = false
        } else if InAppPurchaseManager.shared.hasProduct, let price = InAppPurchaseManager.shared.premiumPriceLocalized {
            cell.priceLabel.text = restore ? "" : price
            cell.backgroundColor = Colors.cellBg
            cell.isUserInteractionEnabled = true
        } else {
            cell.priceLabel.text = Strings.Premium.loadingPriceLabel
            InAppPurchaseManager.shared.requestProduct { success in
                if success, InAppPurchaseManager.shared.hasProduct, let price = InAppPurchaseManager.shared.premiumPriceLocalized  {
                    cell.priceLabel.text = price
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func setupCloseCell(_ cell: ClosePremiumCell) {
        if let countdownSeconds = closeCountdownSeconds {
            cell.startCountdown(seconds: countdownSeconds)
        } else {
            cell.backgroundColor = Colors.cellBg
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
        } else if section == PremiumSection.buy.rawValue {
            return 2
        } else {
            return 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        
        switch(indexPath.section) {
        case PremiumSection.buy.rawValue:
            if let buyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "buyCell", for: indexPath) as? BuyPremiumCell {
                self.setupBuyCell(buyCell, restore: indexPath.row == 1)
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
                featureCell.backgroundColor = Colors.cellBg
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
            height = 85.0
        case PremiumSection.close.rawValue:
            height = 85.0
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
            showPurchaseAlert(restore: indexPath.row == 1)
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
                AdvertisingController.shared.dismiss()
            }
        }
    }
    
    private func showPurchaseAlert(restore: Bool) {
        paymentInProgress = true
        collectionView.reloadData()
        
        if restore {
            InAppPurchaseManager.shared.restorePremiumPurchase { success in
                if success {
                    let alert = UIAlertController(title: Strings.Premium.restoredTitle, message: Strings.Premium.restoredMessage, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.dismiss(animated: true)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: Strings.Premium.errorTitle, message: Strings.Premium.errorMessage, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.collectionView.reloadData()
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                }
                
                self.paymentInProgress = false
                self.collectionView.reloadData()
            }
        } else {
            InAppPurchaseManager.shared.purchase { success in
                if success {
                    let alert = UIAlertController(title: Strings.Premium.purchaseConfirmationTitle, message: Strings.Premium.purchaseConfirmationMessage, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.dismiss(animated: true)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: Strings.Premium.errorTitle, message: Strings.Premium.errorMessage, preferredStyle: .alert)
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
}
