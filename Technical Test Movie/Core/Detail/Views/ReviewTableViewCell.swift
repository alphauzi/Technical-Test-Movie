//
//  ReviewTableViewCell.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 22/05/25.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupItem(data: Review) {
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.height / 2
        self.avatarImage.clipsToBounds = true
        
        self.authorLabel.text = data.author
        self.contentLabel.text = data.content
        
        let date = dateFormat(date: data.createdAt ?? "")
        self.dateLabel.text = date
        
        let rating = String("\(data.authorDetails?.rating ?? 0)")
        ratingLabel.text = "★ " + rating + "   "
        ratingLabel.textColor = .white
        ratingLabel.backgroundColor = .red
        ratingLabel.layer.cornerRadius = 5
        ratingLabel.layer.masksToBounds = true
        ratingLabel.textAlignment = .center
          
        guard let imgURL = data.authorDetails?.avatarPath else {
            return self.avatarImage.image = UIImage(systemName: "person.fill")
        }
        if let imgURL = URL(string: "https://image.tmdb.org/t/p/w200" + imgURL) {
            self.avatarImage.sd_setImage(with: imgURL, placeholderImage: UIImage(systemName: "person.fill"))
        }
        
    }
    
    func dateFormat(date: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM dd, yyyy"
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = isoFormatter.date(from: date) {
            return displayFormatter.string(from: date)
        } else {
            return ""
        }
    }

}
