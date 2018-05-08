//
//  NetworkMockTest.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation


struct NetworkMockErrorTest: NetworkRessource {
    func fetchCurrentRate(completionHandler: @escaping (CurrentRateResponse) -> (), failureHandler: @escaping FailureHandler) {
        let error = BRError.message(title: "Error", message: "Error occured")
        failureHandler(error)
    }
    
    func fetchHistoryRate(from fromDate: Date, to toDate: Date, currency: String, completionHandler: @escaping (HistoryRateResponse) -> (), failureHandler: @escaping FailureHandler) {
        let error = BRError.message(title: "Error", message: "Error occured")
        failureHandler(error)
    }
}

struct NetworkMockTest: NetworkRessource {
    func fetchCurrentRate(completionHandler: @escaping (CurrentRateResponse) -> (), failureHandler: @escaping FailureHandler) {
        
        let bundle = Bundle.main
        
        guard let url = bundle.url(forResource: "current", withExtension: "json") else {
            fatalError("Missing current.json")
        }
        
        let jsonData = try! Data(contentsOf: url)
        let dataResponse : CurrentRateResponse = try! JSONDecoder().decode(CurrentRateResponse.self, from: jsonData)
        completionHandler(dataResponse)
    }
    
    func fetchHistoryRate(from fromDate: Date, to toDate: Date, currency: String, completionHandler: @escaping (HistoryRateResponse) -> (), failureHandler: @escaping FailureHandler) {
        let bundle = Bundle.main
        
        guard let url = bundle.url(forResource: "history", withExtension: "json") else {
            fatalError("Missing history.json")
        }
        
        let jsonData = try! Data(contentsOf: url)
        let dataResponse : HistoryRateResponse = try! JSONDecoder().decode(HistoryRateResponse.self, from: jsonData)
        completionHandler(dataResponse)
    }
}
