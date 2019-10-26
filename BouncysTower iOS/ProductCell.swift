//
//  ProductCellTableViewCell.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 14.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    
    var product: ShopProduct?

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productCostLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
