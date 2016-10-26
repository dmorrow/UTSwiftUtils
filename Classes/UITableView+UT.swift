//
//  UITableView+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9, *)
extension UITableView {
    public func isLastInSection(indexPath:IndexPath) -> Bool {
        guard indexPathIsValid(indexPath) else { return false }
        if let lastItem = self.dataSource?.tableView(self, numberOfRowsInSection:indexPath.section) {
            return lastItem - 1 == (indexPath as NSIndexPath).row
        }
        return false
    }
    
    public func indexPathIsValid(_ indexPath:IndexPath) -> Bool {
        guard let dataSource = self.dataSource, indexPath.row > -1 && indexPath.section > -1 else { return false }
        if indexPath.section < dataSource.numberOfSections!(in: self) {
            if indexPath.row < dataSource.tableView(self, numberOfRowsInSection: indexPath.section) {
                return true
            }
        }
        return false
    }
    
    public func lastIndexPath(section:Int) -> IndexPath {
        if let lastItem = self.dataSource?.tableView(self, numberOfRowsInSection: section) {
            return IndexPath(row: lastItem-1, section: section)
        }
        return IndexPath(row: NSNotFound, section: section)
    }
    
    public func lastIndexPath() -> IndexPath {
        if let numberOfSections = self.dataSource?.numberOfSections!(in: self) {
            return lastIndexPath(section: numberOfSections-1)
        }
        return IndexPath(row: 0, section: 0)
    }
    
    public func scrollToLastRow(animated:Bool) {
        self.scrollToRow(at: self.lastIndexPath(), at: .bottom, animated: animated)
    }
    
    public func register<T: UITableViewCell>(_: T.Type) where T: Reusable, T:NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.identifier)
    }
    
    public func register<T: UITableViewCell>(_: T.Type) where T:Reusable {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
    
}
