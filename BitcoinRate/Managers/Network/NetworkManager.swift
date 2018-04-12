//
//  NetworkManager.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

// This protocol will allow to mock the network layer when unit test the project
protocol NetworkRessource {
   
    func fetchCurrentRate(completionHandler: @escaping (CurrentRateResponse) -> (), failureHandler: @escaping FailureHandler)
    func fetchHistoryRate(from fromDate: Date, to toDate: Date, currency: String, completionHandler: @escaping (HistoryRateResponse) -> (), failureHandler: @escaping FailureHandler)
}

public typealias FailureHandler = (BRError)->(Void)

struct NetworkManager {
    
    public static let `default` = NetworkManager()
    
    // MARK: Methods
    
    init() { }
    
    @discardableResult
    public func callRequest<T: Codable>(request: URLRequest, withSuccess success: @escaping (T)->Void, andFailure failure: @escaping FailureHandler) -> URLSessionDataTask {
      
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    let customError = BRError.error(error)
                    failure(customError)
                }
            } else {
                
                if let data = data, let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.isStatusOK {
                        let decoder = JSONDecoder()
                        let decodedResult = try! decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            success(decodedResult)
                        }
                    } else {
                        
                        DispatchQueue.main.async {
                            let error = BRError.message(title: "Error API", message: "\(httpResponse)")
                            failure(error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let error = BRError.message(title: "Error decoding", message: "Failed to decode object")
                        failure(error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
}
