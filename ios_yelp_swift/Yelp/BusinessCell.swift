//
//  BusinessCell.swift
//  Yelp
//
//  Created by YingYing Zhang on 9/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var reviewsCountLabel: UILabel!
  
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            //thumbImageView.setImageWith(business.imageURL!)
            if business.imageURL != nil {
                thumbImageView.setImageWith(business.imageURL!)
            } else {
                //thumbImageView.setImageWith(UIImage(named:"bizimage-small.png"))
                thumbImageView.image = UIImage(named:"bizimage-small.png")
            }
            addressLabel.text = business.address
            distanceLabel.text = business.distance
            categoriesLabel.text = business.categories
            ratingImageView.setImageWith(business.ratingImageURL!)
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
