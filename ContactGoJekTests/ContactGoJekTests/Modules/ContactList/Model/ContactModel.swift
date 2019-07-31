//
//  ContactModel.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

struct ContactModel: Codable {
    
    let contactId: Int
    var firstName: String
    var lastName: String
    var profilePicUrl: String
    var favorite: Bool
    let contactInfoUrl: String
    
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
        case contactInfoUrl = "url"
    }
    
    mutating func convertToContactModel(from model: ContactDetailModel) -> ContactModel {
        
        firstName = model.firstName
        lastName = model.lastName
        profilePicUrl = model.profilePicUrl
        favorite = model.favorite
        
        return self
    }
}
