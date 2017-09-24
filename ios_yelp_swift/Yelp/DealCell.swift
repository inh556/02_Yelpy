//
//  DealCell.swift
//  Yelp
//
//  Created by YingYing Zhang on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DealCellDelegate {
    @objc optional func dealCell(DealCell: DealCell, didChangeValue value: Bool)
}

class DealCell: UITableViewCell {

    
    @IBOutlet weak var dealLabel: UILabel!
    
    @IBOutlet weak var onDealSwitch: UISwitch!
    
    weak var delegate: DealCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onDealSwitch(_ sender: Any) {
        delegate?.dealCell?(DealCell: self, didChangeValue: onDealSwitch.isOn)
    }
}
