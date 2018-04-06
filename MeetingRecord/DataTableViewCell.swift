//
//  DataTableViewCell.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/15.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var classifyLabel: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var checkBox: UIImageView!
    
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var rankingImage: UIImageView!
    @IBOutlet weak var colorButton: UIButton!
    
    @IBOutlet weak var belowName: UILabel!
    
    @IBOutlet weak var newHight: NSLayoutConstraint!
    @IBOutlet weak var newWidth: NSLayoutConstraint!
    @IBOutlet weak var newTop: NSLayoutConstraint!
    @IBOutlet weak var newLeft: NSLayoutConstraint!
    
    @IBOutlet weak var imgLeft: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHight: NSLayoutConstraint!
    @IBOutlet weak var imgBottom: NSLayoutConstraint!
    
    @IBOutlet weak var colorNameLabel: UILabel!
    
    @IBOutlet weak var ratioLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
