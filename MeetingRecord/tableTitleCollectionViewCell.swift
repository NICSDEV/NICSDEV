//
//  tableTitleCollectionViewCell.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/15.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit

class tableTitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sele: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        self.sele.isHidden = true
        super.awakeFromNib()
        // Initialization code
    }

}
