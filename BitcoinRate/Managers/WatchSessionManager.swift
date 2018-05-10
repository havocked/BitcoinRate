//
//  WatchSessionManager.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import WatchKit
import WatchConnectivity
import PromiseKit

struct Keys {
    static let WatchAskUpdate = "WatchAskUpdate"
}

final class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let `default` = WatchSessionManager()
    
    private let networkManager : NetworkRessource = CachedWebservice()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    private var validSession: WCSession? {
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    // Private init so that we use only the singleton
    private override init() {
        super.init()
    }
    
    /// Initialize the WCSession object
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    /// Retreive data from network/cache and share it to Watch with WCSession *updateApplicationContext* method
    private func retreiveHistoryRates() {
        let endDate = Date()
        
        // Get the date 2 weeks before the current date
        let fromDate = Calendar.current.date(byAdding: .weekOfMonth, value: -2, to: endDate) ?? Date()
        
        let currency = "EUR"
        
        let currentRateQuery = networkManager.fetchCurrentRate()
        let historyQuery = networkManager.fetchHistoryRate(from: fromDate, to: endDate, currency: currency)
        
        firstly {
            when(fulfilled: currentRateQuery, historyQuery)
        }.done { currentRateResponse, historyResponse in
            
            let historyResult = MainViewModel.process(historyResponse, currency: currency)
            let encoder = JSONEncoder()
            let encodedHistoryResult = try encoder.encode(historyResult)
            let currentRate = currentRateResponse.bpi[currency]
            let encodedCurrentRateResult = try encoder.encode(currentRate)
            
            try self.updateApplicationContext(applicationContext: ["history": encodedHistoryResult,
                                                                   "currentRate": encodedCurrentRateResult])
            
        }.catch { error in
            print("Failed to fetch history - \(error)")
            try? self.updateApplicationContext(applicationContext: ["Error": "Network failed"])
        }
    }
    
    /**
     * Called when the session has completed activation.
     * If session state is WCSessionActivationStateNotActivated there will be an error with more details.
     */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation completed: \(activationState)")
        if let err = error {
            print(err)
        }
    }
    
    /**
     * Called when the session can no longer be used to modify or add any new transfers and,
     * all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur.
     * This will happen when the selected watch is being changed.
     */
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session did become active")
    }
    /**
     * Called when all delegate callbacks for the previously selected watch has occurred.
     * The session can be re-activated for the now selected watch using activateSession.
     */
    func sessionDidDeactivate(_ session: WCSession) {
        print("Session did deactivate ")
    }
}

// MARK: Application Context
// use when your app needs only the latest information
// if the data was not sent, it will be replaced
extension WatchSessionManager {
    // Sender
    func updateApplicationContext(applicationContext: [String : Any]) throws {
        if let session = validSession {
            do {
                // We add a UUID so that the updateApplication is always called even if it has the same values in applicationContext
                var payload : [String: Any] = ["uuid": NSUUID().uuidString]
                payload.merge(applicationContext) { (current, _) in current }
                
                try session.updateApplicationContext(payload)
            } catch let error {
                throw error
            }
        }
    }
}

// MARK: Interactive Messaging
extension WatchSessionManager {

    // Receiver
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if let _ = message[Keys.WatchAskUpdate] {
            retreiveHistoryRates()
        }
    }
}

// MARK: Extension for NetworkRessource in order to use PromiseKit Framework

fileprivate extension NetworkRessource {
    func fetchCurrentRate() -> Promise<CurrentRateResponse> {
        return Promise { seal in
            fetchCurrentRate(completionHandler: { response in
                seal.fulfill(response)
            }, failureHandler: { (error) -> (Void) in
                seal.reject(error)
            })
        }
    }
    
    func fetchHistoryRate(from fromDate: Date, to toDate: Date, currency: String) -> Promise<HistoryRateResponse> {
        return Promise { seal in
            fetchHistoryRate(from: fromDate, to: toDate, currency: currency, completionHandler: { response in
                seal.fulfill(response)
            }, failureHandler: { error in
                seal.reject(error)
            })
        }
    }
}
