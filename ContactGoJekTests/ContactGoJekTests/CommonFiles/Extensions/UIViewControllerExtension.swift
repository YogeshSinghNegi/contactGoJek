//
//  UIViewControllerExtension.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 29/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

extension UIViewController {
    
    ///Not using static as it won't be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
}
