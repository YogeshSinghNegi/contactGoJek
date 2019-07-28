//
//  EndPointEnum.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

enum ContactServiceEndPoint {
    
    case getContacts
    case getSingleContact(Int)
    
    var getURL: URL {
        switch self {
        case .getContacts:
            return URL(string: "\(NetworkManager.shared.baseUrl)contacts.json")!
        case .getSingleContact(let contactId):
            return URL(string: "\(NetworkManager.shared.baseUrl)contacts/\(contactId).json")!
        }
    }
    
    var getParameter: [String:AnyObject] {
        switch self {
        case .getContacts, .getSingleContact:
            return [:]
        }
    }
    
    var getMethod: String {
        switch self {
        case .getContacts, .getSingleContact:
            return "GET"
        }
    }
}
