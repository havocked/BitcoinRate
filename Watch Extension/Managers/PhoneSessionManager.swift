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
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    /**
     * Called when the session has completed activation.
     * If session state is WCSessionActivationStateNotActivated there will be an error with more details.
     */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            self.delegate?.phoneManagerIsReady(self)
        }
        if let err = error {
            print(err)
        }
    }
}

// MARK: Application Context
// use when your app needs only the latest information
// if the data was not sent, it will be replaced
extension PhoneSessionManager {
    
    // Receiver
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        // handle receiving application context
        DispatchQueue.main.async() {
            // make sure to put on the main queue to update UI!
            self.delegate?.phoneManager(self, didReceived: applicationContext)
        }
    }

}

// MARK: Interactive Messaging
extension PhoneSessionManager {
    
    // Live messaging! App has to be reachable
    private var validReachableSession: WCSession? {
        if session.isReachable {
            return session
        }
        return nil
    }
    
    // Sender
    
    func sendMessage(message: [String : Any], replyHandler: (([String : Any]) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
}
