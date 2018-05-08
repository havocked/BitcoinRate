//
//  HeaderView.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

@IBDesignable
class HeaderView: NibSettable {
    @IBOutlet weak var centeredLabel: UILabel!
    
    override func setupUI() {
        centeredLabel.text = "yolo"
    }

    func configure(with model: HeaderViewModel) {
        centeredLabel.text = model.title
    }
}
