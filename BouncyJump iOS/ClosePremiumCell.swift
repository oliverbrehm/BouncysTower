//
//  ClosePremiumCell.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 14.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

class ClosePremiumCell: UICollectionViewCell {
    @IBOutlet weak var closeLabel: UILabel!
    
    private var countdownSecondsLeft = 0
    private var countdownStarted = false
    
    var isReadyToClose: Bool {
        return countdownSecondsLeft <= 0
    }
    
    func startCountdown(seconds: Int) {
        if(!countdownStarted) {
            countdownStarted = true
            self.countdownSecondsLeft = seconds + 1
            self.countdown()
        }
    }
    
    private func countdown() {
        self.countdownSecondsLeft -= 1

        if(updateCloseButton()) {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.countdown()
        }
    }
    
    // returns true is there is no countdown left
    private func updateCloseButton() -> Bool {
        if(self.isReadyToClose) {
            DispatchQueue.main.async {
                self.closeLabel.isEnabled = true
                self.closeLabel.text = "CONTINUE"
                self.backgroundColor = Colors.cellBg
            }
            return true
        } else {
            DispatchQueue.main.async {
                self.closeLabel.isEnabled = false
                self.closeLabel.text = "\(self.countdownSecondsLeft)"
                self.backgroundColor = UIColor.darkGray
            }
            return false
        }
    }
}
