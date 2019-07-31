//
//  ContactTableViewCell.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

//MARK:- Contact Listing Cell Class
class ContactTableViewCell: UITableViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var userPofilePicImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favImageIcon: UIImageView!
    
    //MARK:- Cell View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func initialSetup() {
        
        
    }
    
    //MARK:- Populate method which sets data to the views
    func populate(with model: ContactModel) {
        
        userNameLabel.text = model.fullName
        favImageIcon.image = model.favorite ? #imageLiteral(resourceName: "home_favourite") : UIImage()
        
        // Setting image from url to image view
        let size = userPofilePicImage.bounds.size
        DispatchQueue.global().async {
            if let url = URL(string: model.profilePicUrl) {
                let image = UIImage.resizedImage(at: url, for: size)
                DispatchQueue.main.async {
                    self.userPofilePicImage.image = image == nil ? #imageLiteral(resourceName: "placeholder_photo") : image
                }
            }
        }
    }
}
