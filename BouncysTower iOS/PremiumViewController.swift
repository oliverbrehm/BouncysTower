//
//  PremiumViewController.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 14.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

class PremiumViewController: UIViewController {
    
    var countdownSeconds: Int?
    
    var closeDelegate: (() -> Void)?

    func setCountdown(seconds: Int) {
        self.countdownSeconds = seconds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeDelegate?()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedPremiumCVC" {
            if let cvc = segue.destination as? PremiumCVC, let seconds = self.countdownSeconds {
                cvc.setCountdown(seconds: seconds)
            }
        }
    }
}