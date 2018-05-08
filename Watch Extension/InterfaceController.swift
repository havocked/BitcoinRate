//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var topLabel: WKInterfaceLabel!
    @IBOutlet var historyTable: WKInterfaceTable!
    
    let result = ["1700.56", "1845.45", "1300.00", "13335.23", "134.02", "12345.34", "4567", "2345.67"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        loadTableData()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    private func loadTableData() {
        
        topLabel.setText("Current Rate\n17000.34 €")
        
        historyTable.setNumberOfRows(result.count, withRowType: "rateTableRowController")
        
        for (index, data) in result.enumerated() {
            let row = historyTable.rowController(at: index) as! RateTableRowController
            row.topLabel.setText("\(data) €")
            row.bottomLabel.setText("07-11-1989")
        }
    }
    
}
