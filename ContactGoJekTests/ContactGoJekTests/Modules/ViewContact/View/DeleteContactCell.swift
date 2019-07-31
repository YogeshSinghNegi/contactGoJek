//
//  DeleteContactCell.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 30/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

class DeleteContactCell: UITableViewCell {
    
    var deleteActionTaken: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func deleteActionBtn(_ sender: Any) {
        if let deleteAction = deleteActionTaken {
            deleteAction()
        }
    }
}
