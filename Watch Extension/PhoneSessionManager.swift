//
//  PhoneSessionManager.swift
//  Watch Extension
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import WatchConnectivity

class PhoneSessionManager: NSObject, WCSessionDelegate {
    
    static let `default` = PhoneSessionManager()
    
    // Reference to the model object.
    //private var shelterSummary = ShelterSummary()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    // App has to be reachable for live messaging.
    private var validReachableSession: WCSession? {
        if let session = session, session.isReachable {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    func requestApplicationContext() {
        // Send a message with a key that your phone expects. You can organize your constants in a
        // series of structs like I did, or hard code a string instead of Key.Request.ApplicationContext.
//        sendMessage(message: ["Key.Request.ApplicationContext": true as AnyObject], replyHandler: nil, errorHandler: nil)
        let message: [String:Any] = ["Key.Request.ApplicationContext": true]
        validReachableSession?.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        // Request new application context when reachability changes.
        requestApplicationContext()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // Receiver
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
        DispatchQueue.main.async() {
            // Update the model object.
            //self?.shelterSummary.updateFromContext(applicationContext)
            
        }
    }
}
