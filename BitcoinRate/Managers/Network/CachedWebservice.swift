//
//  CachedWebservice.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation


struct FileStorage {
    let baseURL: URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    subscript(key: String) -> Data? {
        get { return try? Data(contentsOf: baseURL.appendingPathComponent(key)) }
        set {
            let url = baseURL.appendingPathComponent(key)
            try? newValue?.write(to: url)
        }
    }
}

final class Cache {
    var storage = FileStorage()
    
    func load<A: Codable>(_ resource: Router) -> A? {
        guard case .get = resource.method else { return nil }
        if let data = storage[resource.cacheKey] {
            let decoder = JSONDecoder()
            let decodedResult = try! decoder.decode(A.self, from: data)
            return decodedResult
        } else {
            return nil
        }
    }
    
    func save<A: Codable>(_ data: A, for resource: Router) {
        guard case .get = resource.method else { return }
        let encoder = JSONEncoder()
        let encodedResult = try! encoder.encode(data)
        storage[resource.cacheKey] = encodedResult
    }
}

/// This class uses The network manager, which usually implements the NetworkRessource protocol, but here CachedWebservice will implement its own, so that we can seperate cache logic and network calls.
struct CachedWebservice : NetworkRessource {
    let networkManager = NetworkManager()
    let cache = Cache()
    
    func fetchCurrentRate(completionHandler: @escaping (CurrentRateResponse) -> (), failureHandler: @escaping FailureHandler) {
        
        // Current rate always needs be fetched, but also cached. So if there is a cache, the completionHandler will be called 2 times.
        
        let router = Router.currentRate
        if let result: CurrentRateResponse = cache.load(router) {
            print("cache hit")
            completionHandler(result)
        }
        
        networkManager.callRequest(request: router.asURLRequest(), withSuccess: { (response: CurrentRateResponse) ->() in
            self.cache.save(response, for: router)
            completionHandler(response)
        }, andFailure: failureHandler)
    }
    
    func fetchHistoryRate(from fromDate: Date, to toDate: Date, currency: String, completionHandler: @escaping (HistoryRateResponse) -> (), failureHandler: @escaping FailureHandler) {
        
        // If there is a cache, then no need to do a network call.
        
        let router = Router.historyRate(start: fromDate, end: toDate, currency: currency)
        if let result: HistoryRateResponse = cache.load(router) {
            print("cache hit")
            completionHandler(result)
        } else {
            networkManager.callRequest(request: router.asURLRequest(), withSuccess: { (response: HistoryRateResponse) ->() in
                self.cache.save(response, for: router)
                completionHandler(response)
            }, andFailure: failureHandler)
        }
    }
}
