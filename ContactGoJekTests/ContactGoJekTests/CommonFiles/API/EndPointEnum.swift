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
    case updateContact(contact: ContactDetailModel)
    case addContact(contact: ContactDetailModel)
    case getSingleContact(Int)
    case deleteContact(Int)
    
    var getURL: URL {
        switch self {
        case .getContacts,.addContact:
            return URL(string: "\(appBaseUrl)contacts.json")!
        case .getSingleContact(let contactId), .deleteContact(let contactId):
            return URL(string: "\(appBaseUrl)contacts/\(contactId).json")!
        case .updateContact(let contact):
            return URL(string: "\(appBaseUrl)contacts/\(contact.contactId).json")!
        }
    }
    
    var getParameter: [String:AnyObject] {
        switch self {
        case .getContacts, .getSingleContact, .deleteContact:
            return [:]
        case .updateContact(let contact):
            var dict = Dictionary<String, AnyObject>()
            dict["first_name"] = contact.firstName as AnyObject
            dict["last_name"] = contact.lastName as AnyObject
            dict["email"] = contact.email as AnyObject
            dict["phone_number"] = contact.phoneNumber as AnyObject
            dict["profile_pic"] = contact.profilePicUrl as AnyObject
            dict["created_at"] = "\(Data())" as AnyObject
            dict["updated_at"] = "\(Data())" as AnyObject
            dict["favorite"] = contact.favorite as AnyObject
            return dict
        case .addContact(let contact):
            var dict = Dictionary<String, AnyObject>()
            dict["first_name"] = contact.firstName as AnyObject
            dict["last_name"] = contact.lastName as AnyObject
            dict["email"] = contact.email as AnyObject
            dict["phone_number"] = contact.phoneNumber as AnyObject
            dict["profile_pic"] = contact.profilePicUrl as AnyObject
            dict["favorite"] = contact.favorite as AnyObject
            return dict
        }
    }
    
    var getMethod: String {
        switch self {
        case .getContacts, .getSingleContact:
            return "GET"
        case .updateContact:
            return "PUT"
        case .addContact:
            return "POST"
        case .deleteContact:
            return "DELETE"
        }
    }
}
