//
//  SwitchCell.swift
//  Yelp
//
//  Created by YingYing Zhang on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

/*
 This is for practice purpose use
 */

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(SwitchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    
    @IBOutlet weak var switchLabel: UILabel!
    
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    //var filter: Filter!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    @IBAction func onSwitch(_ sender: Any) {
        //print("value has changed")
        delegate?.switchCell?(SwitchCell: self, didChangeValue: onOffSwitch.isOn)
    }
    
}
