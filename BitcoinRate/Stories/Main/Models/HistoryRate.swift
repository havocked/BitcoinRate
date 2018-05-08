//
//  HistoryRate.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct HistoryRate {
    var date: Date
    var rate: Float
    var currency: String
    
    init?(dateString: String, rate _rate: Float, currency _currency: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let _date = formatter.date(from: dateString) {
            date = _date
        } else {
            return nil
        }
        
        rate = _rate
        currency = _currency
    }
}
