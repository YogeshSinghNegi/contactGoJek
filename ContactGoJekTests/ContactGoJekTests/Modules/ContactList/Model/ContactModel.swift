//
//  ContactModel.swift
//  ContactGoJekTests
//
//  Created by Aishwarya Rastogi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

struct ContactModel: Codable {
    
    var contactId: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var profilePicUrl: String = ""
    var favorite: Bool = false
    var contactInfoUrl: String = ""
    
    var fullName: String {
        
        var completeName = ""
        if !firstName.isEmpty {
            completeName = firstName
        }
        if !lastName.isEmpty {
            completeName += " \(lastName)"
        }
        return completeName
    }
    
    enum CodingKeys: String, CodingKey {
        
        case contactId = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePicUrl = "profile_pic"
        case favorite = "favorite"
        case contactInfoUrl = "url"
    }
}
