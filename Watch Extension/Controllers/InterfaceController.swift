//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

final class InterfaceController: WKInterfaceController {

    @IBOutlet var currentRateLabel: WKInterfaceLabel!
    @IBOutlet var currentSubtitleLabel: WKInterfaceLabel!
    @IBOutlet var historyLabel: WKInterfaceLabel!
    @IBOutlet var historyTable: WKInterfaceTable!
    
    private var viewModel = InterfaceViewModel()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        viewModel.delegate = self
        self.currentRateLabel.setText(viewModel.currentRateTitle())
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        viewModel.retreiveHistoryRate()
    }
}

extension InterfaceController : InterfaceViewModelDelegate {
    func interfaceViewModel(model: InterfaceViewModel, didFailWith error: Error) {
        print("[InterfaceViewModel] An error occured")
    }
    
    func interfaceViewModelDidUpdateData(viewModel: InterfaceViewModel) {
        
        // Update Current rate label
        
        self.currentRateLabel.setText(viewModel.currentRateTitle())
        
        // Update tableView
        
        historyTable.setNumberOfRows(viewModel.totalFetchedRates, withRowType: "rateTableRowController")
        
        for index in 0 ..< viewModel.totalFetchedRates {
            let row = historyTable.rowController(at: index) as! RateTableRowController
            let model = viewModel.rateTableRowModel(for: index)
            row.configure(with: model)
        }
    }
}
