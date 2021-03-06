//
//  HeaderView.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

@IBDesignable
final class HeaderView: NibSettable {
    @IBOutlet weak var centeredLabel: UILabel!
    
    override func setupUI() {
        centeredLabel.text = "\("HEADER_CURRENT_RATE_TITLE".localized):\n-"
        self.centeredLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
    }

    func configure(with model: HeaderViewModel) {
        centeredLabel.text = model.title
    }
}
