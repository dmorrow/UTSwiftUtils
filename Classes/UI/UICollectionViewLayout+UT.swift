//
//  UICollectionViewLayout+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9, *)
extension UICollectionViewLayout {
    
    public func isLastInSection(indexPath:IndexPath) -> Bool {
        if let collection = self.collectionView, let lastItem = collection.dataSource?.collectionView(collection, numberOfItemsInSection: indexPath.section) {
            return lastItem - 1 == indexPath.row
        }
        return false
    }
    
    public func isInLastLine(indexPath:IndexPath) -> Bool {
        if let collection = self.collectionView, let dataSource = collection.dataSource {
            let lastItemRow = dataSource.collectionView(collection, numberOfItemsInSection: indexPath.section) - 1
            
            let lastItem = IndexPath(item:lastItemRow, section:indexPath.section)
            if let lastItemAttributes = self.layoutAttributesForItem(at: lastItem), let thisItemAttributes = self.layoutAttributesForItem(at: indexPath) {
                return lastItemAttributes.frame.minY == thisItemAttributes.frame.minY
            }
        }
        return false
    }
    
    public func isLastInLine(indexPath:IndexPath) -> Bool {
        let nextIndexPath = IndexPath(item: indexPath.row+1, section: indexPath.section)
        
        if let cellAttributes = self.layoutAttributesForItem(at: indexPath), let nextCellAttributes = self.layoutAttributesForItem(at: nextIndexPath) {
            return !(cellAttributes.frame.minY == nextCellAttributes.frame.minY)
        }
        return false
    }
}
