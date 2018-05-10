//
//  CachedWebservice.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

fileprivate struct FileStorage {
    private let baseURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    subscript(key: String) -> Data? {
        get {
            guard let baseURL = baseURL else {
                return nil
            }
            return try? Data(contentsOf: baseURL.appendingPathComponent(key))
        }
        set {
            if let url = baseURL?.appendingPathComponent(key) {
                try? newValue?.write(to: url)
            }
        }
    }
    
    func clearDiskCache() {
        guard let baseURL = baseURL else {
            return
        }
        let fileManager = FileManager.default
        guard let filePaths = try? fileManager.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil, options: []) else {
            return
        }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
}

/// Cache class is managing the loading and saving of ressources gotten from specific Router objects
final class Cache {
    private var storage = FileStorage()
    
    func load<A: Codable>(_ resource: Router) -> A? {
        guard case .get = resource.method else { return nil }
        if let data = storage[resource.cacheKey] {
            let decoder = JSONDecoder()
            
            do {
                let decodedResult = try decoder.decode(A.self, from: data)
                return decodedResult
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func save<A: Codable>(_ data: A, for resource: Router) {
        guard case .get = resource.method else {
            return
        }
        
        let encoder = JSONEncoder()
        if let encodedResult = try? encoder.encode(data) {
            storage[resource.cacheKey] = encodedResult
        } else {
            print("Failed to save data for \(resource.cacheKey) - Encoding error")
        }
    }
    
    /// Delete all data stored in cache
    func clearCache() {
        storage.clearDiskCache()
    }
}

/// CachedWebservice uses the NetworkManager class, which usually is the one which implements the NetworkRessource protocol. Here CachedWebservice will implement its own, so that we can seperate cache logic and network calls.
struct CachedWebservice : NetworkRessource {
    private let networkManager = NetworkManager()
    private let cache = Cache()
    
    func clearCache() {
        cache.clearCache()
    }
    
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
            print("Launch Network request")
            networkManager.callRequest(request: router.asURLRequest(), withSuccess: { (response: HistoryRateResponse) ->() in
                self.cache.save(response, for: router)
                completionHandler(response)
            }, andFailure: failureHandler)
        }
    }
}
