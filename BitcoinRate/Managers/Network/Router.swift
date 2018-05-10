//
//  Router.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum Router {
    
    private static let baseURLString = Bundle.main.infoDictionary!["Coindesk_Api_Base_Url"] as! String
    private static let apiVersion = Bundle.main.infoDictionary!["Coindesk_Api_Version"] as! String
    
    case currentRate
    case historyRate(start: Date, end: Date, currency: String)
    
    var method : HTTPMethod {
        switch self {
        case .currentRate:
            return .get
        case .historyRate:
            return .get
        }
    }
    
    var path : String {
        switch self {
        case .currentRate:
            return "/bpi/currentprice.json"
        case .historyRate:
            return "/bpi/historical/close.json"
        }
    }
    
    var requestHeaders: [String:String] {
        var headers = [String:String]()
        
        switch self {
        case .currentRate:
            headers["Content-Type"] = "application/json"
        case .historyRate:
            headers["Content-Type"] = "application/json"
        }
        
        return headers
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .currentRate:
            return nil
        case .historyRate(let start, let end, let currency):
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            
            let startString = format.string(from: start)
            let endString = format.string(from: end)
            
            let startQuery = URLQueryItem(name: "start", value: startString)
            let endQuery = URLQueryItem(name: "end", value: endString)
            let currencyQuery = URLQueryItem(name: "currency", value: currency)
            
            return [startQuery, endQuery, currencyQuery]
        }
    }

    func asURLRequest() -> URLRequest {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = Router.baseURLString
        urlComponent.path = "/\(Router.apiVersion)\(path)"
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            fatalError("Url components is wrongly created!")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = requestHeaders
        
        return request
    }
}

extension Router {
    
    /// Is used as a dictionnary key when we want to save data in cache, gotten from a specific router.
    var cacheKey: String {
        return "cache\(self.asURLRequest().hashValue)"
    }
}
