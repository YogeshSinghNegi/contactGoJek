//
//  ContactViewHeader.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 31/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

class ContactViewHeader: UITableViewCell {
    
    var messageActionTaken: (() -> Void)?
    var callActionTaken: (() -> Void)?
    var emailActionTaken: (() -> Void)?
    var favUnfavActionTaken: (() -> Void)?

    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageIcon: UIImageView!
    @IBOutlet weak var callIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var backGradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initialSetup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        backGradientView.addGradient(colorTop: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), colorBottom: #colorLiteral(red: 0.3137254902, green: 0.8901960784, blue: 0.7607843137, alpha: 0.28))
    }
    
    @IBAction func messageBtnTapped(_ sender: Any) {
        if let action = messageActionTaken {
            action()
        }
    }
    
    @IBAction func callBtnTapped(_ sender: Any) {
        if let action = callActionTaken {
            action()
        }
    }
    
    @IBAction func emailBtnTapped(_ sender: Any) {
        if let action = emailActionTaken {
            action()
        }
    }
    
    @IBAction func favUnfavBtnTapped(_ sender: Any) {
        if let action = favUnfavActionTaken {
            action()
        }
    }
    
    private func initialSetup() {
        
        profilePicImage.round()
        profilePicImage.setBorder(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), borderWidth: 1.5)
    }
    
    private func addGradient() {
        
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = backGradientView.frame.size
        gradient.colors = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor,#colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1).cgColor]
        backGradientView.layer.addSublayer(gradient)
    }
    
    func populateViews(model: ContactDetailModel) {
        
        favouriteIcon.isHighlighted = model.favorite
        userNameLabel.text = model.fullName
        profilePicImage.loadImageUsingCache(withUrl: model.profilePicUrl, placholder: #imageLiteral(resourceName: "placeholder_photo"))
    }
}
