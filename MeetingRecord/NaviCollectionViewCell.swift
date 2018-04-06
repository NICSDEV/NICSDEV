//
//  NaviCollectionViewCell.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/10.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit

class NaviCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var progress: OProgressView!
    @IBOutlet weak var header: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sele: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        progress.setProgress(progress.progress + 45, animated: true)

    }

}
