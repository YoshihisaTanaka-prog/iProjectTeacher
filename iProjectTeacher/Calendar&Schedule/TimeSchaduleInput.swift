//
//  TimeSchaduleInput.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/05/27.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit

class TimeScaduleInput{
    
    var timeText: String
    var timeNum: Int
    var status: String
    var statusColor: UIColor
    
    init(_ timeNum: Int, _ status: String){
        
        self.timeText = timeNum.s + ":00 ~ " + (timeNum + 1).s + ":00"
        self.timeNum = timeNum
        self.status = status
        
        switch status {
        case "selected":
            self.statusColor = UIColor(red: 1.f, green: 0.f, blue: 0.f, alpha: 1.f)
        case "favorite":
            self.statusColor = UIColor(red: 0.4.f, green: 0.8.f, blue: 1.f, alpha: 1.f)
        default:
            self.statusColor = UIColor(red: 1.f, green: 1.f, blue: 0.5.f, alpha: 1.f)
        }
    }
    
    init(_ timeNum: Int, _ teacherStatus: String, _ studentStatus: String){
        
        self.timeText = timeNum.s + ":00 - " + (timeNum + 1).s + ":00"
        self.timeNum = timeNum
        self.status = margeStatus(teacherStatus, studentStatus)
        
        switch status {
        case "selected":
            self.statusColor = UIColor(red: 1.f, green: 0.f, blue: 0.f, alpha: 1.f)
        case "favorite":
            self.statusColor = UIColor(red: 0.4.f, green: 0.8.f, blue: 1.f, alpha: 1.f)
        case "onlyTeacherFavorite":
            self.statusColor = UIColor(red: 0.5.f, green: 1.f, blue: 0.5.f, alpha: 1.f)
        case "onlyStuderntFavorite":
            self.statusColor = UIColor(red: 0.5.f, green: 1.f, blue: 0.5.f, alpha: 1.f)
        default:
            self.statusColor = UIColor(red: 1.f, green: 1.f, blue: 0.5.f, alpha: 1.f)
        }
        
        func margeStatus(_ teacherStatus: String, _ studentStatus: String) -> String {
            if teacherStatus == "selected" {
                return "selected"
            }
            if studentStatus == "selected" {
                return "selected"
            }
            if teacherStatus == "favorite" && studentStatus == "favorite" {
                return "favorite"
            }
            if teacherStatus == "favorite"{
                return "onlyTeacherFavorite"
            }
            if studentStatus == "favorite"{
                return "onlyStuderntFavorite"
            }
            return ""
        }
    }
}
