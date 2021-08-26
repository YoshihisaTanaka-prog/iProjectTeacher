//
//  ChatRoomTableViewCell.swift
//  ChatTest4
//
//  Created by 田中義久 on 2021/08/21.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var roomNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.layer.cornerRadius = 30
        iconImageView.clipsToBounds = true
        self.backgroundColor = dColor.base
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
