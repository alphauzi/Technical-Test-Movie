//
//  DetailViewController.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 21/05/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie?.title
        
    }

}
