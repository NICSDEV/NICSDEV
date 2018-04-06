//
//  popHeaderTableViewCell.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/29.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit

class popHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var myTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
