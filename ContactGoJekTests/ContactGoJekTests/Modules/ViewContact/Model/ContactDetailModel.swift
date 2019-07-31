//
//  ContactDetailModel.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

struct ContactDetailModel: Codable {
    
    let createdAt: String
    let email: String
    var favorite: Bool
    let firstName: String
    let contactId: Int
    let lastName: String
    let phoneNumber: String
    let profilePicUrl: String
    let updatedAt: String
    
    //Getting complete name from first name and last name
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
        case email = "email"
        case phoneNumber = "phone_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
