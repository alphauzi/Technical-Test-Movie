//
//  MovieItemCollectionViewCell.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 21/05/25.
//

import UIKit
import SDWebImage

class MovieItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var shimmerCoverView: ShimmerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.coverImageView.isHidden = true
        self.shimmerCoverView.startAnimating()
    }
    
    func setupItem(data: Movie) {
        let imgURL = data.posterPath ?? ""
        if let imgURL = URL(string: "https://image.tmdb.org/t/p/w200" + imgURL) {
            self.coverImageView.sd_setImage(with: imgURL) { _, _, _, _ in
                self.shimmerCoverView.isHidden = true
                self.coverImageView.isHidden = false
            }
        }
    }
    
}
