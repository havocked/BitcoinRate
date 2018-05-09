//
//  InterfaceViewModel.swift
//  Watch Extension
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

typealias ProcessedData = (title: String, date: String)

protocol InterfaceViewModelDelegate: class {
    func interfaceViewModel(model: InterfaceViewModel, didUpdate data: [ProcessedData])
}

final class InterfaceViewModel: NSObject {
    
    private var fetchedData = [String]()
    
    weak var delegate: InterfaceViewModelDelegate?
    
    override init() {
        super.init()
    }
    
    func retreiveData() {
        WatchSessionManager.sharedManager.sendMessage(message: [Keys.WatchAskUpdate : true])
    }
}
