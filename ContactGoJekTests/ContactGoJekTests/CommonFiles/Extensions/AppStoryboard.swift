//
//  AppStoryboard.swift
//  ContactGoJekTests
//
//  Created by Aishwarya Rastogi on 29/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation
import UIKit

//MARK:- This is used to instantiate the storyboard and returns it
enum AppStoryboard : String {
    
    case Main
}

extension AppStoryboard {
    
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(_ viewControllerClass : T.Type,
                                              function : String = #function, // debugging purposes
        line : Int = #line,
        file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(self)
    }
}

