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
}
