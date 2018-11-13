//
//  UIImage+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9, *)
extension UIImage {
    
    public convenience init?(color: UIColor = UIColor.clear, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    public func roundedCorners(_ radius:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let bounds = CGRect(origin: .zero, size: self.size)
        UIBezierPath(roundedRect: bounds, cornerRadius: radius).addClip()
        self.draw(in: bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
    
    public func croppedImage(_ bounds:CGRect) -> UIImage? {
        if let imageRef = (self.cgImage)?.cropping(to: bounds) {
            let croppedImage = UIImage(cgImage: imageRef)
            return croppedImage
        }
        return nil        
    }
    
    public func composite(image: UIImage) -> UIImage {
        guard let cgImage = self.cgImage, let compositeImage = image.cgImage, let colorSpace = compositeImage.colorSpace else { return self }
        let bounds1 = CGRect(origin: .zero, size: image.size)
        let bounds2 = CGRect(origin: .zero, size: self.size)
        if let ctx = CGContext(data: nil, width: compositeImage.width, height: compositeImage.height, bitsPerComponent: compositeImage.bitsPerComponent, bytesPerRow: compositeImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) {
            ctx.draw(cgImage, in: bounds2)
            ctx.setBlendMode(CGBlendMode.normal) // one image over the other
            ctx.draw(compositeImage, in: bounds1)
            if let newImage = ctx.makeImage() {
                return UIImage(cgImage: newImage)
            }
        }
        return self
    }
    
    public func sized(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
    
    public func resizeImageWithAspect(scaledToMaxWidth width: CGFloat, maxHeight height: CGFloat)->UIImage {
        let oldWidth = self.size.width
        let oldHeight = self.size.height
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight
        
        let newHeight = oldHeight * scaleFactor
        let newWidth = oldWidth * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        return self.sized(newSize)
    }
    
    public func mask(color: UIColor) -> UIImage {
        
        guard let maskImage = self.cgImage else { return self }
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(origin: .zero, size: self.size)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        if let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) {
            bitmapContext.clip(to: bounds, mask: maskImage)
            bitmapContext.setFillColor(color.cgColor)
            bitmapContext.fill(bounds)
            
            if let cImage = bitmapContext.makeImage() {
                let coloredImage = UIImage(cgImage: cImage)
                return coloredImage
            }
        }
        return self
    }
    
    public func normalized() -> UIImage {
        
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        return self
    }
}
