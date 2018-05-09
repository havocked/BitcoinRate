//
//  RateTableRowModel.swift
//  Watch Extension
//
//  Created by Nataniel Martin on 09/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct RateTableRowModel {
    
    var title: String
    var subtitle: String
    
    init(historyRate: HistoryRate) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        title = "\(historyRate.rate) \(historyRate.currency)"
        subtitle = formatter.string(from: historyRate.date)
    }
}
