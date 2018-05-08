//
//  Currency.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct Currency: Codable {
    var code : String
    var symbol: String
    var rate: String
    var description: String
    var rate_float: Float
}
