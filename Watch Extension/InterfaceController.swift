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

    @IBOutlet var topLabel: WKInterfaceLabel!
    @IBOutlet var historyTable: WKInterfaceTable!
    
    private var viewModel = InterfaceViewModel()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        viewModel.delegate = self
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        viewModel.retreiveData()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

//    private func loadTableData() {
//
//        topLabel.setText("Current Rate\n17000.34 €")
//
//        historyTable.setNumberOfRows(result.count, withRowType: "rateTableRowController")
//
//        for (index, data) in result.enumerated() {
//            let row = historyTable.rowController(at: index) as! RateTableRowController
//            row.topLabel.setText("\(data) €")
//            row.bottomLabel.setText("07-11-1989")
//        }
    //    }
    
}

extension InterfaceController : InterfaceViewModelDelegate {
    func interfaceViewModel(model: InterfaceViewModel, didUpdate data: [ProcessedData]) {
        historyTable.setNumberOfRows(data.count, withRowType: "rateTableRowController")
        
        for (index, data) in data.enumerated() {
            let row = historyTable.rowController(at: index) as! RateTableRowController
            row.topLabel.setText(data.title)
            row.bottomLabel.setText(data.date)
        }
    }
}
