//
//  NetworkManager.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    
    private override init() { }
    
    // MARK: Shared Instance
    static let shared: NetworkManager = NetworkManager()
    
    //Base Url
    let baseUrl = "http://gojek-contacts-app.herokuapp.com/"
    
    //Common Method to hit a service
    public func hitService(_ endPoint: ContactServiceEndPoint) {
        
        //Make Header as common
        let headers = ["Content-Type": "application/json"]
        
        //Make post data from parameters
        let postData = try? JSONSerialization.data(withJSONObject: endPoint.getParameter, options: [])
        
        //Common Request with respective URL
        let request = NSMutableURLRequest(url: endPoint.getURL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = endPoint.getMethod
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse)
            }
        })
        
        dataTask.resume()
    }
    
}
