//
//  UICollectionViewExtension.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 22/05/25.
//

import Foundation
import UIKit

extension UICollectionView{
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: cellType)
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue UICollectionViewCell with identifier: \(identifier)")
        }
        return cell
    }

}
