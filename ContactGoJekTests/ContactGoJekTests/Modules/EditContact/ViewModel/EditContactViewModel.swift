//
//  EditContactViewModel.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

protocol EditContactViewModelProtocol {
    
    var contactList: ContactDetailModel? { get set }
    func getContactFromApi()
    func updateContactUsingApi()
    func addContactUsingApi()
}

protocol EditContactDelegate: AnyObject {
    
    func contactAdded()
    func contactUpdated()
    func contactFetched()
    func errorOccured(_ errorMessage: String)
}

class EditContactViewModel: EditContactViewModelProtocol {
    
    weak var delegate: EditContactDelegate?
    var contactList: ContactDetailModel?
    let networkManager: NetworkManagerProtocol
    
    init(EditContactDelegate: EditContactDelegate, contactList: ContactDetailModel) {
        
        self.delegate = EditContactDelegate
        self.contactList = contactList
        self.networkManager = NetworkManager()
    }
    
    func getContactFromApi() {
        
        guard let model = contactList else { return }
        networkManager.hitService(.getSingleContact(model.contactId), { response in
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
    
    func updateContactUsingApi() {
        
        guard let model = contactList, checkForValidData() else { return }
        networkManager.hitService(.updateContact(contact: model), { response in
            let contactList = try? JSONDecoder().decode(ContactDetailModel.self, from: response)
            if let contact = contactList {
                self.contactList = contact
                self.delegate?.contactUpdated()
            } else {
                self.delegate?.errorOccured("Error")
            }
        }) { error in
            self.delegate?.errorOccured("Error")
        }
    }
    
    func addContactUsingApi() {
        
        guard let model = contactList, checkForValidData() else { return }
        networkManager.hitService(.addContact(contact: model), { response in
            let contactList = try? JSONDecoder().decode(ContactDetailModel.self, from: response)
            if let contact = contactList {
                self.contactList = contact
                self.delegate?.contactAdded()
            } else {
                self.delegate?.errorOccured("Error")
            }
        }) { error in
            self.delegate?.errorOccured("Error")
        }
    }
    
    private func checkForValidData() -> Bool {
        guard let model = contactList else { return false }
        if model.firstName.isEmpty {
            self.delegate?.errorOccured("First Name cannot be null")
            return false
        }
        if model.lastName.isEmpty {
            self.delegate?.errorOccured("Last Name cannot be null")
            return false
        }
        if !model.phoneNumber.isEmpty && model.phoneNumber.count < 10 {
            self.delegate?.errorOccured("Phone number cannot be less than 10 digits")
            return false
        }
        if !checkValidEmail(email: model.email) {
            self.delegate?.errorOccured("Entered email is not correct")
            return false
        }
        return true
    }
    
    private func checkValidEmail(email: String) -> Bool {
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: email)
    }
}


