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
    
    private let premiumFeatureCellIdentifier = "featureCell"
    private let buyPremiumCellIdentifier = "buyCell"
    private let closePremiumCellIdentifier = "closePremiumCell"
    
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
    
    private var closeCountdownSeconds: Int?
    
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
        let cell: UICollectionViewCell
        
        switch(indexPath.section) {
        case PremiumSection.buy.rawValue:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: buyPremiumCellIdentifier, for: indexPath)
        case PremiumSection.close.rawValue:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: closePremiumCellIdentifier, for: indexPath)
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: premiumFeatureCellIdentifier, for: indexPath)
        }
        
        if let buyCell = cell as? BuyPremiumCell {
            // TODO get price
            buyCell.backgroundColor = UIColor(named: "cellBg") ?? UIColor.white
        } else if let featureCell = cell as? PremiumFeatureCell {
            let description = self.featureList[indexPath.row]
            featureCell.featureDescriptionTextView.text = description
            featureCell.backgroundColor = UIColor(named: "cellBg") ?? UIColor.white
        } else if let closeCell = cell as? ClosePremiumCell {
            if let countdownSeconds = closeCountdownSeconds {
                closeCell.startCountdown(seconds: countdownSeconds)
            } else {
                closeCell.backgroundColor = UIColor(named: "cellBg") ?? UIColor.white
            }
        }
        
        cell.layer.cornerRadius = 8.0
        
        return cell
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
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == PremiumSection.buy.rawValue) {
            let alert = UIAlertController(title: "Buy Premium", message: "TODO", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
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
}
