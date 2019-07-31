//
//  ContactViewHeader.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 31/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

class ContactViewHeader: UITableViewCell {

    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageIcon: UIImageView!
    @IBOutlet weak var callIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var favouriteIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func initialSetup() {
        
        profilePicImage.setBorder(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), borderWidth: 1.5)
    }
    
    func populateViews(model: ContactDetailModel) {
        
        userNameLabel.text = model.fullName
        profilePicImage.image = #imageLiteral(resourceName: "placeholder_photo")
    }
}
