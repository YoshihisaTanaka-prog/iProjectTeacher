//
//  StudentTableViewCell.swift
//  iProjectTeacher
//
//  Created by Ring Trap on 7/8/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let size = screenSizeG["EnEt"]!
        self.contentView.frame = CGRect(x: 0.f, y: 0.f, width: size.width, height: size.viewHeight)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
