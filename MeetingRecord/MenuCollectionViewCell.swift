//
//  MenuCollectionViewCell.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/11.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var susume: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var backGroud: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var subName: UILabel!
    @IBOutlet weak var imageHight: NSLayoutConstraint!
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    @IBOutlet weak var TopMargin: NSLayoutConstraint!
    @IBOutlet weak var rightMargin: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabelTopMargin: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colorLabel.layer.cornerRadius = 15
        self.colorLabel.layer.masksToBounds = true
        // Initialization code
    }
}
