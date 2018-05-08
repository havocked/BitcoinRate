//
//  HTTPURLResponse+Extension.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var isStatusOK : Bool {
        switch statusCode {
        case 200 ... 299:
            return true
        default:
            return false
        }
    }
}
