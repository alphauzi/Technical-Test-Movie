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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupItem(data: Movie) {
        self.layer.cornerRadius = 10
          
        let imgURL = data.posterPath ?? ""
        if let imgURL = URL(string: "https://image.tmdb.org/t/p/w200" + imgURL) {
            self.coverImageView.sd_setImage(with: imgURL, placeholderImage: UIImage(systemName: "movieclapper.fill"))
        }
    }
    
}
