//
//  GetConactDataCellTableViewCell.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 30/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

class GetConactDataCellTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var enterField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setIntialSetup()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        contentView.endEditing(true)
    }
    
    private func setIntialSetup() {
        
        fieldNameLabel.text = ""
        enterField.text = ""
    }
    
    public func populateForViewContact(model: ContactDetailModel, index: Int) {
        enterField.isUserInteractionEnabled = false
        switch index {
        case 0:
            fieldNameLabel.text = "mobile"
            enterField.text = model.phoneNumber
        case 1:
            fieldNameLabel.text = "email"
            enterField.text = model.email
        default:
            fieldNameLabel.text = ""
            enterField.text = ""
        }
    }
    
    public func populateForEditContact(model: ContactDetailModel, index: Int) {
        enterField.isUserInteractionEnabled = true
        switch index {
        case 0:
            fieldNameLabel.text = "First Name"
            enterField.text = model.firstName
            enterField.keyboardType = .default
            enterField.returnKeyType = .next
        case 1:
            fieldNameLabel.text = "Last Name"
            enterField.text = model.lastName
            enterField.keyboardType = .default
            enterField.returnKeyType = .next
        case 2:
            fieldNameLabel.text = "mobile"
            enterField.text = model.phoneNumber
            enterField.keyboardType = .phonePad
            enterField.returnKeyType = .next
        case 3:
            fieldNameLabel.text = "email"
            enterField.text = model.email
            enterField.keyboardType = .emailAddress
            enterField.returnKeyType = .done
        default:
            fieldNameLabel.text = ""
            enterField.text = ""
        }
    }
}
