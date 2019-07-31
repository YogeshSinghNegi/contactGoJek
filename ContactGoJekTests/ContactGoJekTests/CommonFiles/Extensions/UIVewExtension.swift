//
//  UIVewExtension.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 31/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

extension UIView {
    
    func setBorder(with borderColor: UIColor, borderWidth: CGFloat) {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = false
    }
    
    func round() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    func setCornor(with borderColor: UIColor, borderWidth: CGFloat) {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = false
    }
    
    func addGradient(colorTop: UIColor, colorBottom: UIColor) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.frame.size
        gradient.colors = [colorTop.cgColor,colorBottom.cgColor]
        self.layer.addSublayer(gradient)
    }
}
