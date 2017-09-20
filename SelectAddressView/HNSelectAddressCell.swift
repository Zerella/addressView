//
//  HNSelectAddressCell.swift
//  SelectAddressView
//
//  Created by Zerella on 2017/9/4.
//  Copyright © 2017年 Zerella. All rights reserved.
//

import UIKit

class HNSelectAddressCell: UITableViewCell {

    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
