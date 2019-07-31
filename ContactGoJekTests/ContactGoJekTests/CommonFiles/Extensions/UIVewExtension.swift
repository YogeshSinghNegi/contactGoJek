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
}
