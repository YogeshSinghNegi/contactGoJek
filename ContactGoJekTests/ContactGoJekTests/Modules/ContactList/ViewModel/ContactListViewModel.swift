//
//  ContactListViewModel.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
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
        
        self.delegate = contactListDelegate
        self.contactList = [(key: String, value: [ContactModel])]()
        self.networkManager = NetworkManager()
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
    }
}
