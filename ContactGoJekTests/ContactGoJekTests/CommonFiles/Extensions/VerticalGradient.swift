//
//  VerticalGradient.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 31/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation
import UIKit

class VerticalGradient: UIView {
    
    private var gdColor1 : UIColor = #colorLiteral(red: 0.3137254902, green: 0.8901960784, blue: 0.7607843137, alpha: 0.55)
    private var gdColor2 : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    @IBInspectable
    open var color1: UIColor! = #colorLiteral(red: 0.3137254902, green: 0.8901960784, blue: 0.7607843137, alpha: 0.55) {
        didSet{
            gdColor1 = color1
        }
    }
    
    @IBInspectable
    open var color2: UIColor! = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet{
            gdColor2 = color2
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.sublayers = nil
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [gdColor2.cgColor,gdColor1.cgColor]
        gradient.frame = rect
        gradient.locations = [0.0,1.0]
        self.layer.addSublayer(gradient)
    }
}
