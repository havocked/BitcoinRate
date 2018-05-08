//
//  MainViewModelTests.swift
//  BitcoinRateTests
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest
@testable import BitcoinRate

// The Unit test scheme is only configured for English.

class MainViewModelTests: XCTestCase {
    
    var viewModel = MainViewModel()
    var lastCurrentTitleReceived: String?
    var didReceiveUpdateDelegate: Bool = false
    var lastErrorOccured: BRError?
    
    override func setUp() {
        super.setUp()
        viewModel = MainViewModel(networkRessource: NetworkMockTest())
        viewModel.delegate = self
        lastCurrentTitleReceived = nil
        didReceiveUpdateDelegate = false
        lastErrorOccured = nil
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertEqual(viewModel.totalRates, 0)
    }
    
    func testCurrentRate() {
        viewModel.getCurrentRate()
        XCTAssertEqual(lastCurrentTitleReceived, "Today\'s Rate:\n7688.89 €")
    }
    
    func testHistoryRates() {
        viewModel.getHistoryRates()
        XCTAssertEqual(viewModel.totalRates, 5)
    }
    
    func testHistoryCellModel() {
        viewModel.getHistoryRates()
        let indexpath = IndexPath(row: 0, section: 0)
        let cellModel = viewModel.historyCellModel(for: indexpath)
        
        XCTAssertEqual(cellModel.date, "Sep 5, 2013")
        XCTAssertEqual(cellModel.rate, "120.533 EUR")
    }
    
    func testErrors() {
        viewModel = MainViewModel(networkRessource: NetworkMockErrorTest())
        viewModel.delegate = self
        viewModel.getCurrentRate()
        XCTAssertNotNil(lastErrorOccured)
    }
}

extension MainViewModelTests : MainViewModelDelegate {
    func mainViewModelDidUpdateHistory(model: MainViewModel) {
        didReceiveUpdateDelegate = true
    }
    
    func mainViewModel(model: MainViewModel, update headerViewModel: HeaderViewModel) {
        lastCurrentTitleReceived = headerViewModel.title
    }
    
    func mainViewModel(model: MainViewModel, showError error: BRError) {
        lastErrorOccured = error
    }
}
