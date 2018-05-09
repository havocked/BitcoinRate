//
//  InterfaceViewModel.swift
//  Watch Extension
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

protocol InterfaceViewModelDelegate: class {
    func interfaceViewModelDidUpdateData(viewModel: InterfaceViewModel)
    func interfaceViewModel(model: InterfaceViewModel, didFailWith error: Error)
}

enum InterfaceError: Error {
    case wrongData // The payload received from iOS app has not the correct key
}

final class InterfaceViewModel: NSObject {
    
    private var sessionManager = PhoneSessionManager()
    private var fetchedHistoryRates = [HistoryRate]()
    private var fetchedCurrentRate : Currency?
    
    weak var delegate: InterfaceViewModelDelegate?
    
    var totalFetchedRates : Int {
        return fetchedHistoryRates.count
    }
    
    override init() {
        super.init()
        sessionManager.delegate = self
        sessionManager.startSession()
    }
    
    /// Launch message to iOS app to retreive new data
    func retreiveHistoryRate() {
        if sessionManager.lastFechtedData.count > 0 {
            processDataAndNotify(data: sessionManager.lastFechtedData)
        }
        if sessionManager.isSessionReady {
            sessionManager.sendMessage(message: [Keys.WatchAskUpdate : true])
        }
    }
    
    /// Create the appropriate model for the specific table row
    func rateTableRowModel(for row: Int) -> RateTableRowModel {
        let rate = self.fetchedHistoryRates[row]
        let model = RateTableRowModel(historyRate: rate)
        return model
    }
    
    func currentRateTitle() -> String {
        if let currency = fetchedCurrentRate {
            return currency.rate
        }
        return "-"
    }
    
    /// Convert dictionnary to [HistoryRate] and notify with delegate
    private func processDataAndNotify(data: [String:Any]) {
        do {
            
            if let historyResult = data["history"] as? Data,
                let currentRateResult = data["currentRate"] as? Data {
                let decoder = JSONDecoder()
                fetchedHistoryRates = try decoder.decode([HistoryRate].self, from: historyResult)
                fetchedCurrentRate = try decoder.decode(Currency.self, from: currentRateResult)
            } else {
                throw InterfaceError.wrongData
            }
            
            self.delegate?.interfaceViewModelDidUpdateData(viewModel: self)
        } catch let err {
            self.delegate?.interfaceViewModel(model: self, didFailWith: err)
        }
    }
}

// MARK: PhoneSession Delegates

extension InterfaceViewModel : PhoneSessionDelegate {
    func phoneManagerIsReady(_ manager: PhoneSessionManager) {
        sessionManager.sendMessage(message: [Keys.WatchAskUpdate : true])
    }
    func phoneManager(_ manager: PhoneSessionManager, didReceived data: [String : Any]) {
        processDataAndNotify(data: data)
    }
}
