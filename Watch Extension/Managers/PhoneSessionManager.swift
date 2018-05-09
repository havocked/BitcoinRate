//
//  WatchSessionManager.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import WatchKit
import WatchConnectivity


struct Keys {
    static let WatchAskUpdate = "WatchAskUpdate"
}

protocol PhoneSessionDelegate : class {
    func phoneManagerIsReady(_ manager: PhoneSessionManager)
    func phoneManager(_ manager: PhoneSessionManager, didReceived data: [String:Any])
}

class PhoneSessionManager: NSObject, WCSessionDelegate {
    
    private let session: WCSession = WCSession.default
    weak var delegate: PhoneSessionDelegate?
    
    var isSessionReady : Bool {
        return self.session.activationState == .activated
    }
    
    var lastFechtedData : [String: Any] {
        return self.session.receivedApplicationContext
    }
    
    // Session for Live messaging
    private var validReachableSession: WCSession? {
        if session.isReachable {
            return session
        }
        return nil
    }
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            self.delegate?.phoneManagerIsReady(self)
        }
        if let err = error {
            print(err)
        }
    }
    
    // MARK: Application Context Receiver
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async() {
            self.delegate?.phoneManager(self, didReceived: applicationContext)
        }
    }
    
    
    // MARK: Interactive Messaging Sender
    
    func sendMessage(message: [String : Any], replyHandler: (([String : Any]) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
}

