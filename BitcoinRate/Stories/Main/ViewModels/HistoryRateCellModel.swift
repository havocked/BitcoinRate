//
//  HistoryRateCellModel.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct HistoryRateCellModel {
    let rate: String
    let date: String
    
    init(historyRate: HistoryRate) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        rate = "\(historyRate.rate) \(historyRate.currency)"
        date = formatter.string(from: historyRate.date)
    }
}
