//
//  StudentInfoTableViewCell.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/02/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class StudentInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var highSchool: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBOutlet var userNameFuriganaLabel: UILabel!
    @IBOutlet weak var firstChoiceLabel: UILabel!
    @IBOutlet weak var secondChoiceLabel: UILabel!
    @IBOutlet weak var thirdChoiceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
