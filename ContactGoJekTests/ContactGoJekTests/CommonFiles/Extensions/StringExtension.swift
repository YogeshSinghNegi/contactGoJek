//
//  StringExtension.swift
//  ContactGoJekTests
//
//  Created by Aishwarya Rastogi on 01/08/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import Foundation

extension String {
    
    ///Removes leading and trailing white spaces from the string
    var byRemovingLeadingTrailingWhiteSpaces:String {
        
        let spaceSet = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: spaceSet)
    }
}
