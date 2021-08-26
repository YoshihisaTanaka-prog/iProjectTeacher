//
//  ReportTableViewCell.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/02/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    //@IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet var subject: UILabel!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userimage.layer.cornerRadius = userimage.frame.width / 2.f
        userimage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
