//
//  YourChatViewCell.swift
//  lime
//
//  Created by 下村一将 on 2017/10/25.
//  Copyright © 2017 kazu. All rights reserved.
//

import UIKit

class YourChatViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var textViewWidthConstraint: NSLayoutConstraint!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.backgroundColor = UIColor.clear
        self.iconImageView.layer.cornerRadius = 15
        self.iconImageView.clipsToBounds = true
		self.textView.layer.cornerRadius = 15// 角を丸める
        textView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        textView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
		self.addSubview(YourBalloonView(frame: CGRect(x: textView.frame.minX-10, y: textView.frame.minY-10, width: 50, height: 50)))//吹き出しのようにするためにビューを重ねる
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}
	
}

extension YourChatViewCell {
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

