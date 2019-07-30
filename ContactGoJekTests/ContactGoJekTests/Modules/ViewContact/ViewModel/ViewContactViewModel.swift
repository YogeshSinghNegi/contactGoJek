//
//  ViewContactViewModel.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

protocol ViewContactViewModelProtocol {
    
    var contactId: Int { get set }
    var contactList: ContactDetailModel? { get }
    func getContactFromApi()
}

protocol ViewContactDelegate: AnyObject {
    
    func contactFetched()
    func errorOccured(_ errorMessage: String)
}

class ViewContactViewModel: ViewContactViewModelProtocol {
    
    weak var delegate: ViewContactDelegate?
    var contactList: ContactDetailModel?
    var contactId: Int
    let networkManager: NetworkManagerProtocol
    
    init(viewContactDelegate: ViewContactDelegate, contactId: Int) {
        
        self.delegate = viewContactDelegate
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


