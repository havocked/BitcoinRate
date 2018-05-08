//
//  HistoryRateCell.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

class HistoryRateCell: UITableViewCell, EasyRegisteredCell {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topLabel.font = UIFont.boldSystemFont(ofSize: 18)
        bottomLabel.font = UIFont.systemFont(ofSize: 12)
        
        topLabel.textColor = UIColor.darkText
        bottomLabel.textColor = UIColor.darkGray
    }
    
    func configure(with model: HistoryRateCellModel) {
        self.topLabel.text = model.rate
        self.bottomLabel.text = model.date
    }
}
