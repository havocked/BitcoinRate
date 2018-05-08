//
//  CurrentRateResponse.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct CurrentRateResponse: Codable {
    var time: ResponseTime
    var disclaimer: String
    var chartName: String
    var bpi: [String:Currency]
}
