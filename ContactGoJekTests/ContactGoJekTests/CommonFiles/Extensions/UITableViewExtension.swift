//
//  UITableViewExtension.swift
//  ContactGoJekTests
//
//  Created by Aishwarya Rastogi on 29/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

extension UITableView {
    
    ///Register Table View Cell Nib
    func registerCell(with identifier: UITableViewCell.Type) {
        self.register(UINib(nibName: "\(identifier.self)",bundle:nil),
                      forCellReuseIdentifier: "\(identifier.self)")
    }
    
    ///Dequeue Table View Cell
    func dequeueCell <T: UITableViewCell> (with identifier: T.Type, indexPath: IndexPath? = nil) -> T {
        if let index = indexPath {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)", for: index) as! T
        } else {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)") as! T
        }
    }
    
    ///Dequeue Header Footer View
    func dequeueHeaderFooter <T: UITableViewHeaderFooterView> (with identifier: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: "\(identifier.self)") as! T
    }
}
