//
//  HeaderViewModel.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation
import StringExtensionHTML

struct HeaderViewModel {
    var title: String
    
    init(currency: Currency) {
        title = "\("HEADER_CURRENT_RATE_TITLE".localized):\n\(currency.rate_float) \(currency.symbol)".stringByDecodingHTMLEntities
    }
}
