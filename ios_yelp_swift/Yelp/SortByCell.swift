//
//  SortByCell.swift
//  Yelp
//
//  Created by YingYing Zhang on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SortByCellDelegate {
    @objc optional func sortByCell(SortByCell: SortByCell, didChangeValue value: Bool)
}

class SortByCell: UITableViewCell {

    weak var delegate: SortByCellDelegate?
    
    
    @IBOutlet weak var sortByLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
