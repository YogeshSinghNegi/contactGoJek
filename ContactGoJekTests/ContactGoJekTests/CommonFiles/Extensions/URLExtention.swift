//
//  URLExtention.swift
//  ContactGoJekTests
//
//  Created by Aishwarya Rastogi on 31/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

extension URL {
    
    var isValidURL: Bool {
        get {
            if let host = self.host, !host.isEmpty {
                return true
            }
            return false
        }
    }
}
