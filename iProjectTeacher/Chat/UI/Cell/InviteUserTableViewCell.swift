//
//  InviteUserTableViewCell.swift
//  ChatTest4
//
//  Created by 田中義久 on 2021/08/22.
//

import UIKit

protocol InviteUserTableViewCellDelegate {
    func tappedSwitch(cell: InviteUserTableViewCell)
}

class InviteUserTableViewCell: UITableViewCell {
    
    var delegate: InviteUserTableViewCellDelegate?
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var isInvitedSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.layer.cornerRadius = 30
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2.f
        self.backgroundColor = dColor.base
        self.setFontColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tappedSwitch(){
        self.delegate?.tappedSwitch(cell: self)
    }
    
}
