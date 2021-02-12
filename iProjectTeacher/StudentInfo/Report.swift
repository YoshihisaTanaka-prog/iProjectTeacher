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
    var objectId: String
    var studentId: String
    var teacherId: String
    
    init(_ report: NCMBObject){
        self.objectId = report.objectId
        self.studentId = report.object(forKey: "studentId") as! String
        self.teacherId = report.object(forKey: "teacherId") as! String
    }
}
