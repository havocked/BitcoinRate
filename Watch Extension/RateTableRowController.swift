//
//  RateTableRowController.swift
//  Watch Extension
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import WatchKit

final class RateTableRowController: NSObject {
    @IBOutlet var topLabel: WKInterfaceLabel!
    @IBOutlet var bottomLabel: WKInterfaceLabel!
    
    func configure(with data: ProcessedData) {
        topLabel.setText(data.title)
        bottomLabel.setText(data.date)
    }
}
