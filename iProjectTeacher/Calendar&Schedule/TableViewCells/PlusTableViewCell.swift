//
//  PlusTableViewCell.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/15.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class PlusTableViewCell: UITableViewCell {
    
    @IBOutlet private var plusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = dColor.base
        self.layer.cornerRadius = 5.f
        self.layer.borderWidth = 1.f
        self.layer.borderColor = dColor.concept.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
