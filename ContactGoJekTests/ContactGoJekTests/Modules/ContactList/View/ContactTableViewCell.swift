//
//  ContactTableViewCell.swift
//  ContactGoJekTests
//
//  Created by Aishwarya Rastogi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userPofilePicImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favImageIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(with model: ContactModel) {
        
        userNameLabel.text = model.fullName
        
        let size = userPofilePicImage.bounds.size
        DispatchQueue.global().async {
            if let url = URL(string: model.profilePicUrl) {
                let image = UIImage.resizedImage(at: url, for: size)
                DispatchQueue.main.async {
                    self.userPofilePicImage.image = image
                }
            }
        }
    }
}
