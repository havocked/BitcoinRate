//
//  WatchSessionManager.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    public static let `default` = WatchSessionManager()
    
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    private var validSession: WCSession? {
        if let session = session, session.isPaired == true, session.isWatchAppInstalled == true, session.isReachable == true {
            return session
        }
        return nil
    }

    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        if session.activationState == .activated {
            updateApplicationContext()
        }
    }
    
    // Construct and send the updated application context to the watch.
    func updateApplicationContext() {
        let context = [String: AnyObject]()
        
        // Now, compute the values from your model object to send to the watch.
        do {
            try self.updateApplicationContext(applicationContext: context)
        } catch {
            print("Error updating application context")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            updateApplicationContext()
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    // Receiver
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject],
                 replyHandler: ([String : AnyObject]) -> Void) {
        if message["Key.Request.ApplicationContext"] != nil {
            updateApplicationContext()
        }
    }
}

// MARK: Application Context
extension WatchSessionManager {
    
    // Sender
    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
    }
    
}
