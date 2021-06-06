//
//  Report.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/02/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB

class Report{
    var ncmb: NCMBObject
    var studentId: String
    var teacherId: String
    var subject: String
    var unit: String
    var attitude: String
    var homework: String
    var nextUnit: String
    var messageToParents: String
    var messageToTeacher: String
    var fileNames: [String] = []
    
    init(_ report: NCMBObject){
        self.ncmb = report
        self.studentId = report.object(forKey: "studentId") as! String
        self.teacherId = report.object(forKey: "teacherId") as! String
        
        self.subject = report.object(forKey: "subject") as! String
        self.unit = report.object(forKey: "unit") as! String
        self.attitude = report.object(forKey: "attitude") as! String
        self.homework = report.object(forKey: "homework") as! String
        self.nextUnit = report.object(forKey: "nextUnit") as! String
        self.messageToParents = report.object(forKey: "messageToParents") as! String
        self.messageToTeacher = report.object(forKey: "messageToTeacher") as! String
        self.fileNames = report.object(forKey: "fileNames") as? [String] ?? []
    }
    
    init(studentId: String, teacherId: String, subject: String, unit: String, attitude: String, homework: String, nextUnit: String, messageToParents: String, messageToTeacher: String){
        self.ncmb = NCMBObject(className: "Report")!
        self.studentId = studentId
        self.teacherId = teacherId
        self.subject = subject
        self.unit = unit
        self.attitude = attitude
        self.homework = homework
        self.nextUnit = nextUnit
        self.messageToParents = messageToParents
        self.messageToTeacher = messageToTeacher
    }
    
}
