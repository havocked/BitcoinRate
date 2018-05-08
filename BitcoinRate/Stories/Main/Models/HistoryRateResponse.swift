//
//  HistoryRateResponse.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct HistoryRateResponse: Codable {
    var bpi: [String: Float]
    var disclaimer: String
    var time: ResponseTime
}
