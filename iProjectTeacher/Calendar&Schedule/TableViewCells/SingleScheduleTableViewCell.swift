//
//  SingleScheduleTableViewCell.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/25.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

protocol ScheduleTableViewCellDelegate {
    func tappedScheduleButton(timeFrame: TimeFrameUnit)
}

class SingleScheduleTableViewCell: UITableViewCell {
    
    var delegate: ScheduleTableViewCellDelegate?
    var timeFrame: TimeFrameUnit!
    
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var detailButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpUI(){
        self.backgroundColor = dColor.base
        
        timeLabel.text = (timeFrame.time / 100).s02 + ":00\n|\n" + (timeFrame.time / 100 + 1).s02 + ":00"
        timeLabel.textAlignment = .center
        detailButton.titleLabel?.numberOfLines = 0
        if timeFrame.eventType == "telecture" {
            let lecture = cachedLectureG[timeFrame.lectureId!]!
            let title = timeFrame.title + "\n教師：" + lecture.teacher.userName + "先生\n生徒：" + lecture.student.userName + "さん"
            detailButton.titleLabel?.textAlignment = .center
            detailButton.setTitle(title, for: .normal)
        } else{
            detailButton.setTitle(timeFrame.title, for: .normal)
        }
        self.setFontColor()
        detailButton.setTitleColor(dColor.font, for: .normal)
        detailButton.layer.borderWidth = 1.f
        detailButton.layer.cornerRadius = 5.f
        switch timeFrame.eventType {
        case "telecture":
            let fbColor = UIColor(iRed: 0, iGreen: 63, iBlue: 0)
            let bColor = UIColor(iRed: 0, iGreen: 255, iBlue: 0)
            setButtonColor(fontBorderColor: fbColor, backgroundColor: bColor)
        case "school":
            let fbColor = UIColor(iRed: 127, iGreen: 0, iBlue: 0)
            let bColor = UIColor(iRed: 255, iGreen: 255, iBlue: 68)
            setButtonColor(fontBorderColor: fbColor, backgroundColor: bColor)
        case "private":
            let fbColor = UIColor(iRed: 127, iGreen: 0, iBlue: 0)
            let bColor = UIColor(iRed: 255, iGreen: 127, iBlue: 192)
            setButtonColor(fontBorderColor: fbColor, backgroundColor: bColor)
        default:
            let fbColor = dColor.font
            let bColor = dColor.base
            setButtonColor(fontBorderColor: fbColor, backgroundColor: bColor)
        }
    }
    
    private func setButtonColor(fontBorderColor: UIColor, backgroundColor: UIColor){
        detailButton.backgroundColor = backgroundColor
        detailButton.layer.borderColor = fontBorderColor.cgColor
        detailButton.setTitleColor(fontBorderColor, for: .normal)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapped(sender: UIButton){
        self.delegate?.tappedScheduleButton(timeFrame: timeFrame)
    }
    
}
