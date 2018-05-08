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

final class InterfaceViewModel {
    
    private var fetchedData = [String]()
    
    weak var delegate: InterfaceViewModelDelegate?
    
    func retreiveData() {
        fetchedData = ["sdadasda", "asdasdas", "John", "Doe", "Cat", "Dog"]
        let processedData = fetchedData.compactMap({ data -> ProcessedData in
            return ("\(data) €", "07-11-1989")
        })
        self.delegate?.interfaceViewModel(model: self, didUpdate: processedData)
    }
}
