//
//  TransformateExtensions.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/06/04.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit



extension Int{
    public var d: Double {
        return Double(self)
    }
    public var f: CGFloat {
        return CGFloat(self)
    }
    public var s: String {
        return String(self)
    }
    public var s02: String {
        return String(format: "%02d", self)
    }
}

extension Double{
    public var i: Int {
        return Int(self)
    }
    public var f: CGFloat {
        return CGFloat(self)
    }
    public var s: String {
        return String(self)
    }
    public var s2: String {
        return String(format: "%.2f", self)
    }
}
extension String{
    public var ary: [String] {
        let cArray = Array(self)
        var ret: [String] = []
        for c in cArray {
            ret.append(String(c))
        }
        return ret
    }
    
    public var upHead: String{
        if self == ""{
            return self
        }
        let array = self.ary
        var ret = array[0].uppercased()
        
        if self.count != 1{
            for i in 1..<array.count{
                ret += array[i]
            }
        }
        
        return ret
    }
}

extension Date{
    public var ymd: String{
        return self.y.s + "/" + self.m.s02 + "/" + self.d.s02
    }
    public var ymdJp: String{
        return self.y.s + "年" + self.m.s02 + "月" + self.d.s02 + "日"
    }
    public var hms: String{
        let c = Calendar.current
        let h = c.component(.hour, from: self)
        let m = c.component(.minute, from: self)
        let s = c.component(.second, from: self)
        return h.s02 + ":" + m.s02 + ":" + s.s02
    }
    public var hmsJp: String{
        let c = Calendar.current
        let h = c.component(.hour, from: self)
        let m = c.component(.minute, from: self)
        let s = c.component(.second, from: self)
        return h.s02 + "時" + m.s02 + "分" + s.s02 + "秒"
    }
    public var hm: String{
        let c = Calendar.current
        let h = c.component(.hour, from: self)
        let m = c.component(.minute, from: self)
        return h.s02 + ":" + m.s02
    }
    public var hmJp: String{
        let c = Calendar.current
        let h = c.component(.hour, from: self)
        let m = c.component(.minute, from: self)
        return h.s02 + "時" + m.s02 + "分"
    }
    public var y: Int{
        let c = Calendar.current
        return c.component(.year, from: self)
    }
    public var m: Int{
        let c = Calendar.current
        return c.component(.month, from: self)
    }
    public var d: Int{
        let c = Calendar.current
        return c.component(.day, from: self)
    }
}

extension UIViewController{
    func transformGrade(_ grade: String) -> String {
        let grades = grade.ary
        var gradeText = "？？？？？"
        if( grades.count != 0 ){
            switch grades[0] {
            case "E":
                gradeText = "小学 "
            case "J":
                gradeText = "中学 "
            case "H":
                gradeText = "高校"
            case "C":
                gradeText = "高専"
            case "R":
                gradeText = "浪人生"
            case "B":
                gradeText = "学部 "
            case "M":
                gradeText = "修士 "
            case "D":
                gradeText = "博士 "
            default:
                break
            }
            if grades.count != 1{
                gradeText += grades[1] + "年生"
            }
        }
        return gradeText
    }
    
    func transformSubject(_ subject: String) -> String{
        let subjectList = ["modernWriting","ancientWiting","chineseWriting","math1a","math2b","math3c","physics","chemistry","biology","earthScience",
            "geography","japaneseHistory","worldHistory","modernSociety","ethics","politicalScienceAndEconomics","hsEnglish"]
        let subjectJpList = ["現代文","古文","漢文","数学Ⅰ・A","数学Ⅱ・B","数学Ⅲ・C","物理","化学","生物","地学",
            "地理","日本史","世界史","現代社会","倫理","政治・経済","高校英語"]
        for i in 0..<subjectList.count{
            if(subject == subjectList[i]){
                return subjectJpList[i]
            }
        }
        return ""
    }
    
}
