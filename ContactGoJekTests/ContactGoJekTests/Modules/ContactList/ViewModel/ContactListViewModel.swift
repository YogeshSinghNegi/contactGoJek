//
//  ContactListViewModel.swift
//  ContactGoJekTests
//
//  Created by Aishwarya Rastogi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

protocol ContactListViewModelProtocol {
    
    var contactList: [(key: String, value: [ContactModel])] { get }
    func getContactFromApi()
}

protocol ContactListDelegate: AnyObject {

    func contactsListFetched()
    func errorOccured(_ errorMessage: String)
}

class ContactListViewModel: ContactListViewModelProtocol {
    
    weak var delegate: ContactListDelegate?
    var contactList: [(key: String, value: [ContactModel])]
    let networkManager: NetworkManagerProtocol
    
    init(contactListDelegate: ContactListDelegate) {
        delegate = contactListDelegate
        contactList = [(key: String, value: [ContactModel])]()
        networkManager = NetworkManager()
    }
    
    func getContactFromApi() {
        networkManager.hitService(.getContacts, { response in
            let contactList = try? JSONDecoder().decode([ContactModel].self, from: response)
            if let contacts = contactList {
                self.contactList = self.getContactSections(contact: contacts)
                self.delegate?.contactsListFetched()
            } else {
                self.delegate?.errorOccured("Error")
            }
        }) { error in
            self.delegate?.errorOccured("Error")
        }
    }
    
    func getContactSections(contact: [ContactModel]) -> [(key: String, value: [ContactModel])] {
        
        var sectionDic = [String: [ContactModel]]()
        contact.forEach { (model) in
            if let firstChar = model.firstName.first {
                let firstLetter = String(firstChar).uppercased()
                if let _ = sectionDic[firstLetter] {
                    sectionDic[firstLetter]?.append(model)
                } else {
                    sectionDic[firstLetter] = [model]
                }
            }
        }
        return sectionDic.sorted { $0.0 < $1.0 }
        /*
        var sections = Dictionary<String, [ContactModel]>()
        var contacts = [ContactModel]()
        var sectionName = ""
        for contactModel in contact {
            if sectionName == "" {
                sectionName =  String(contactModel.firstName.first!)
            }
            if String(contactModel.firstName.first!) == sectionName {
                contacts.append(contactModel)
            } else {
                sections[sectionName] = contacts
                sectionName = String(contactModel.firstName.first!)
                contacts = [ContactModel]()
                contacts.append(contactModel)
            }
        }

        if sectionName != "" {
            sections[sectionName] = contacts
        }
        return sections
 */
    }
}
