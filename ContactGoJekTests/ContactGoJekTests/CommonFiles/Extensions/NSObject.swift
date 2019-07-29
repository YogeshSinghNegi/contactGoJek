//
//  NSObject.swift
//  ContactGoJekTests
//
//  Created by Aishwarya Rastogi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
