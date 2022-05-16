//
//  UIImage.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-05-15.
//

import UIKit

extension UIImage {
    /// Return a new image with modified orientation, scale and size
    /// - Parameter image: the image to modify
    /// - Returns: the new modified image
    func normalizedImage() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        if let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        
        return UIImage()
    }
    
    /// Return a new image with modified size
    /// - Parameters:
    ///   - sourceImage: the image to modify
    ///   - newWidth: the width to make the new image
    /// - Returns: the new modified image
    func resize(newWidth: CGFloat) -> UIImage {
        let oldWidth = self.size.width
        let scaleFactor = newWidth / oldWidth
        let newHeight = self.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        self.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
