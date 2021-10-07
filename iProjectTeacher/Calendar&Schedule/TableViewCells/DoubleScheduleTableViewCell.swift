//
//  DoubleScheduleTableViewCell.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/26.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class DoubleScheduleTableViewCell: UITableViewCell {
    
    var delegate: ScheduleTableViewCellDelegate?
    var myTimeFrame: TimeFrameUnit!
    var yourTimeFrame: TimeFrameUnit!
    
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var myDetailButton: UIButton!
    @IBOutlet private var yourDetailButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpUI(){
        self.backgroundColor = dColor.base
        
        timeLabel.text = (myTimeFrame.time / 100).s02 + ":00\n|\n" + (myTimeFrame.time / 100 + 1).s02 + ":00"
        timeLabel.textAlignment = .center
        
        if myTimeFrame.eventType == "telecture" {
            let lecture = cachedLectureG[myTimeFrame.lectureId!]!
            let title = myTimeFrame.title + "\n" + lecture.teacher.userName + "先生\n" + lecture.student.userName + "さん"
            myDetailButton.titleLabel?.numberOfLines = 3
            myDetailButton.titleLabel?.textAlignment = .center
            myDetailButton.setTitle(title, for: .normal)
        } else{
            myDetailButton.setTitle(myTimeFrame.title, for: .normal)
        }
        myDetailButton.tag = 1
        
        if yourTimeFrame.eventType == "telecture" {
            let lecture = cachedLectureG[yourTimeFrame.lectureId!]!
            let title = yourTimeFrame.title + "\n教師：" + lecture.teacher.userName + "先生\n生徒：" + lecture.student.userName + "さん"
            yourDetailButton.titleLabel?.numberOfLines = 3
            yourDetailButton.titleLabel?.textAlignment = .center
            yourDetailButton.setTitle(title, for: .normal)
        } else{
            yourDetailButton.setTitle(yourTimeFrame.title, for: .normal)
        }
        yourDetailButton.tag = 2
        self.setFontColor()
        
        myDetailButton.layer.borderWidth = 1.f
        myDetailButton.layer.cornerRadius = 5.f
        myDetailButton.titleLabel?.numberOfLines = 0
        yourDetailButton.layer.borderWidth = 1.f
        yourDetailButton.layer.cornerRadius = 5.f
        yourDetailButton.titleLabel?.numberOfLines = 0
        switch myTimeFrame.eventType {
        case "telecture":
            let fbColor = UIColor(iRed: 0, iGreen: 127, iBlue: 0)
            let bColor = UIColor(iRed: 0, iGreen: 255, iBlue: 0)
            setButtonColor(button: myDetailButton, fontBorderColor: fbColor, backgroundColor: bColor)
        case "school":
            let fbColor = UIColor(iRed: 127, iGreen: 0, iBlue: 0)
            let bColor = UIColor(iRed: 255, iGreen: 255, iBlue: 68)
            setButtonColor(button: myDetailButton, fontBorderColor: fbColor, backgroundColor: bColor)
        case "private":
            let fbColor = UIColor(iRed: 127, iGreen: 0, iBlue: 0)
            let bColor = UIColor(iRed: 255, iGreen: 127, iBlue: 192)
            setButtonColor(button: myDetailButton, fontBorderColor: fbColor, backgroundColor: bColor)
        default:
            let fbColor = dColor.font
            let bColor = dColor.base
            setButtonColor(button: myDetailButton, fontBorderColor: fbColor, backgroundColor: bColor)
        }
        switch yourTimeFrame.eventType {
        case "telecture":
            let fbColor = UIColor(iRed: 0, iGreen: 127, iBlue: 0)
            let bColor = UIColor(iRed: 0, iGreen: 255, iBlue: 0)
            setButtonColor(button: yourDetailButton, fontBorderColor: fbColor, backgroundColor: bColor)
        case "school":
            let fbColor = UIColor(iRed: 127, iGreen: 0, iBlue: 0)
            let bColor = UIColor(iRed: 255, iGreen: 255, iBlue: 68)
            setButtonColor(button: yourDetailButton, fontBorderColor: fbColor, backgroundColor: bColor)
        case "private":
            let fbColor = UIColor(iRed: 127, iGreen: 0, iBlue: 0)
            let bColor = UIColor(iRed: 255, iGreen: 127, iBlue: 192)
            setButtonColor(button: yourDetailButton, fontBorderColor: fbColor, backgroundColor: bColor)
        default:
            let fbColor = dColor.font
            let bColor = dColor.base
            setButtonColor(button: yourDetailButton, fontBorderColor: fbColor, backgroundColor: bColor)
        }
    }
    
    private func setButtonColor(button: UIButton, fontBorderColor: UIColor, backgroundColor: UIColor){
        button.backgroundColor = backgroundColor
        button.layer.borderColor = fontBorderColor.cgColor
        button.setTitleColor(fontBorderColor, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapped(sender: UIButton){
        switch sender.tag {
        case 1:
            self.delegate?.tappedScheduleButton(timeFrame: myTimeFrame)
        case 2:
            self.delegate?.tappedScheduleButton(timeFrame: yourTimeFrame)
        default:
            break
        }
    }
    
}
