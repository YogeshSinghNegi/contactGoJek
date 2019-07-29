//
//  NetworkManager.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

//MARK:- NetworkManager Protocol to hit a service
protocol NetworkManagerProtocol {
    
    func hitService(_ endPoint: ContactServiceEndPoint, _ success: @escaping(Data) -> Void, _ failure: @escaping(Error) -> Void)
}

//MARK:- NetworkManager class for Api purpose
class NetworkManager: NetworkManagerProtocol {
    
    func hitService(_ endPoint: ContactServiceEndPoint, _ success: @escaping (Data) -> Void, _ failure: @escaping (Error) -> Void) {
        
        //Make Header as common
        let headers = ["Content-Type": "application/json"]
        
        //Make post data from parameters
        
        //Common Request with respective URL
        let request = NSMutableURLRequest(url: endPoint.getURL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 100.0)
        request.httpMethod = endPoint.getMethod
        if endPoint.getMethod.uppercased() == "POST" {
            let postData = try? JSONSerialization.data(withJSONObject: endPoint.getParameter, options: [])
            request.httpBody = postData
        }
        request.allHTTPHeaderFields = headers

        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil, let error = error {
                failure(error)
            } else if let data = data {
                success(data)
            }
        })
        
        dataTask.resume()
    }
}
