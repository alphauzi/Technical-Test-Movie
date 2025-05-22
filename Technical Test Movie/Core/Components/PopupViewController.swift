//
//  PopupViewController.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 22/05/25.
//

import UIKit

class PopupViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.layer.cornerRadius = 20
    }
    
    @IBAction func tryAgainButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
