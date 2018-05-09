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
    case wrongData
}

final class InterfaceViewModel: NSObject {
    
    private var sessionManager = PhoneSessionManager()
    private var fetchedHistoryRates = [HistoryRate]()
    
    weak var delegate: InterfaceViewModelDelegate?
    
    var totalFetchedRates : Int {
        return fetchedHistoryRates.count
    }
    
    override init() {
        super.init()
        sessionManager.delegate = self
        sessionManager.startSession()
    }
    
    func retreiveHistoryRate() {
        if sessionManager.lastFechtedData.count > 0 {
            processDataAndNotify(data: sessionManager.lastFechtedData)
        }
        if sessionManager.isSessionReady {
            sessionManager.sendMessage(message: [Keys.WatchAskUpdate : true])
        }
    }
    
    func processDataAndNotify(data: [String:Any]) {
        do {
            self.fetchedHistoryRates = try processHistoryRate(with: data)
            self.delegate?.interfaceViewModelDidUpdateData(viewModel: self)
        } catch let err {
            self.delegate?.interfaceViewModel(model: self, didFailWith: err)
        }
    }
    
    func rateTableRowModel(for row: Int) -> RateTableRowModel {
        let rate = self.fetchedHistoryRates[row]
        let model = RateTableRowModel(historyRate: rate)
        return model
    }
    
    private func processHistoryRate(with data: [String : Any]) throws -> [HistoryRate] {
        if let result = data["result"] as? Data {
            let rates = try JSONDecoder().decode([HistoryRate].self, from: result)
            return rates
        } else {
            throw InterfaceError.wrongData
        }
    }
}

extension InterfaceViewModel : PhoneSessionDelegate {
    func phoneManagerIsReady(_ manager: PhoneSessionManager) {
        sessionManager.sendMessage(message: [Keys.WatchAskUpdate : true])
    }
    func phoneManager(_ manager: PhoneSessionManager, didReceived data: [String : Any]) {
        processDataAndNotify(data: data)
    }
}
