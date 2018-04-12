//
//  MainViewModel.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

protocol MainViewModelDelegate: class {
    func mainViewModelDidUpdateHistory(model: MainViewModel)
    func mainViewModel(model: MainViewModel, update headerViewModel: HeaderViewModel)
    func mainViewModel(model: MainViewModel, showError error: BRError)
}

final class MainViewModel {
    
    private var networkManager : NetworkRessource
    
    private var fetchedRates = [HistoryRate]()
    
    weak var delegate: MainViewModelDelegate?
    
    var totalRates: Int {
        get {
            return self.fetchedRates.count
        }
    }
    
    // MARK: Public Methods
    
    init(networkRessource: NetworkRessource = CachedWebservice()) {
        // Use Mock response when UI testing
        if let _ = ProcessInfo.processInfo.environment["-ShouldMockResponse"] {
            networkManager = NetworkMockTest()
        } else {
            networkManager = networkRessource
        }
    }
    
    func getCurrentRate() {
        networkManager.fetchCurrentRate(completionHandler: { [unowned self] response in
            if let currency = response.bpi["EUR"] {
                let headerViewModel = HeaderViewModel(currency: currency)
                self.delegate?.mainViewModel(model: self, update: headerViewModel)
            }
        }) { [unowned self] error in
            self.delegate?.mainViewModel(model: self, showError: error)
        }
    }
    
    func getHistoryRates() {
        let endDate = Date()
        
        // Get the date 2 weeks before the current date
        let fromDate = Calendar.current.date(byAdding: .weekOfMonth, value: -2, to: endDate)
        
        let currency = "EUR"
        networkManager.fetchHistoryRate(from: fromDate!, to: endDate, currency: currency, completionHandler: { [unowned self] response in
            self.process(response, currency: currency)
        }) { [unowned self] error in
            self.delegate?.mainViewModel(model: self, showError: error)
        }
    }
  
    func historyCellModel(for indexPath: IndexPath) -> HistoryRateCellModel {
        let rate = fetchedRates[indexPath.row]
        let model = HistoryRateCellModel(historyRate: rate)
        return model
    }
    
    // MARK: Private methods
    
    /// Process HistoryRateResponse to retreive and sort fetched rates by descending date
    private func process(_ response: HistoryRateResponse, currency: String) {
        
        self.fetchedRates = response.bpi.compactMap({ (key, value) -> HistoryRate? in
            let rate = HistoryRate(dateString: key, rate: value, currency: currency)
            return rate
        }).sorted(by: { (first, second) -> Bool in
            return first.date.compare(second.date) == .orderedDescending
        })
        self.delegate?.mainViewModelDidUpdateHistory(model: self)
    }
    
}
