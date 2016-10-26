//
//  UICollectionView+UT.swift
//  UTSwiftUtils
//
//  Created by Danny Morrow on 10/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    public func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable, T:NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    public func register<T: UICollectionViewCell>(_: T.Type) where T:Reusable {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}
