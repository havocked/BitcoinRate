//
//  NetworkMockTest.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation


/// NetworkMockErrorTest implements NetworkRessource to be injected during Unit test.
/// Is used when we want to test error case both in UI and Unit test
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

/// NetworkMockTest implements NetworkRessource to be injected during Unit test.
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
