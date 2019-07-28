//
//  ImageViewExtension.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

//Below Extension will be used to download image from given url and also will help in the cache maintaining.
let imageCache = NSCache<NSString,UIImage>()
extension UIImage {
    
    static func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString){
            return imageFromCache
        }
        
        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else {
                return nil
        }
        
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: image.bitsPerComponent,
                                bytesPerRow: image.bytesPerRow,
                                space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                bitmapInfo: image.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(image, in: CGRect(origin: .zero, size: size))
        
        guard let scaledImage = context?.makeImage() else { return nil }
        imageCache.setObject(UIImage(cgImage: scaledImage), forKey: url.absoluteString as NSString)
        
        return UIImage(cgImage: scaledImage)
    }
}
