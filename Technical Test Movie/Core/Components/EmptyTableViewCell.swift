//
//  EmptyTableViewCell.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 22/05/25.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    static let cellId = "EmptyTableViewCell"
    
    private lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 17, weight: .regular)
        return lbl
    }()
    
    func configure(){
        self.label.text = "No reviews available at the moment."
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            ])
    }
}
