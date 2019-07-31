//
//  UIImageViewExtension.swift
//  ContactGoJekTests
//
//  Created by Aishwarya Rastogi on 31/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

//Below Extension will be used to download image in the given size from given url and also will help in the cache maintaining.
let imageCache = NSCache<NSString,UIImage>()
extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString : String, placholder: UIImage) {
        
        self.image = placholder
        let url = URL(string: urlString)
        if let finalURL = url,
            !finalURL.isValidURL { return }
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        }).resume()
    }
}
