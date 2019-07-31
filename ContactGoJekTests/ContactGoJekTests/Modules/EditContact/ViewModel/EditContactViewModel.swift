//
//  EditContactViewModel.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

protocol EditContactViewModelProtocol {
    
    var contactId: Int { get set }
    var contactList: ContactDetailModel? { get }
    func getContactFromApi()
}

protocol EditContactDelegate: AnyObject {
    
    func contactFetched()
    func errorOccured(_ errorMessage: String)
}

class EditContactViewModel: EditContactViewModelProtocol {
    
    weak var delegate: EditContactDelegate?
    var contactList: ContactDetailModel?
    var contactId: Int
    let networkManager: NetworkManagerProtocol
    
    init(EditContactDelegate: EditContactDelegate, contactId: Int) {
        
        self.delegate = EditContactDelegate
        self.contactId = contactId
        self.networkManager = NetworkManager()
    }
    
    func getContactFromApi() {
        
        networkManager.hitService(.getSingleContact(contactId), { response in
            let fetchedContact = try? JSONDecoder().decode(ContactDetailModel.self, from: response)
            if let contact = fetchedContact {
                self.contactList = contact
                self.delegate?.contactFetched()
            } else {
                self.delegate?.errorOccured("Error")
            }
        }) { error in
            self.delegate?.errorOccured("Error")
        }
    }
}


