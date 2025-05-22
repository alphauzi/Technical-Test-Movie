//
//  UITableViewCellExtension.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 22/05/25.
//

import Foundation
import UIKit

extension UITableView{
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: cellType)
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue UITableViewCell with identifier: \(identifier)")
        }
        return cell
    }
}
