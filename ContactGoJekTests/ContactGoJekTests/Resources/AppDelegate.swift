//
//  AppDelegate.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 27/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.initialViewController()
        return true
    }
    
    func initialViewController() {
        
        let contactListViewController = ContactListViewController.instantiate(fromAppStoryboard: .Main)
        contactListViewController.viewModel = ContactListViewModel(contactListDelegate: contactListViewController)
        let navigationController = UINavigationController(rootViewController: contactListViewController)
        self.window?.rootViewController = navigationController
    }
}

