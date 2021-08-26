//
//  YourGroupChatViewCell.swift
//  ChatTest2
//
//  Created by 田中義久 on 2021/01/23.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class YourGroupChatViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var textViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.iconImageView.layer.cornerRadius = 15
        self.iconImageView.clipsToBounds = true
        self.textView.layer.cornerRadius = 15// 角を丸める
        self.addSubview(YourBalloonView(frame: CGRect(x: textView.frame.minX-10, y: textView.frame.minY-10, width: 50, height: 50)))//吹き出しのようにするためにビューを重ねる
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension YourGroupChatViewCell {
    func updateCell(text: String, time: String) {
        self.textView?.text = text
        self.timeLabel?.text = time
        
        let frame = CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
        var rect = self.textView.sizeThatFits(frame)
        if(rect.width<30){
            rect.width=30
        }
        textViewWidthConstraint.constant = rect.width//テキストが短くても最小のビューの幅を30とする
    }
}
