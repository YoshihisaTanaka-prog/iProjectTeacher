//
//  Schedule.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/03.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB

protocol LectureDelegate {
    func savedLecture()
}

class Lecture {
    var delegate: LectureDelegate?
    
    var ncmb: NCMBObject
    var student: User?
    var teacher: User?
    var timeList: [Date]
    var subject: String
    var subjectName: String
    var detail: String
    var teacherAttendanceTime = 0
    var studentAttendanceTime = 0
    var isAbleToEdit: Bool
    
//    読み取り用
    init(lecture: NCMBObject, _ vc: UIViewController){
        ncmb = lecture
        timeList = lecture.object(forKey: "timeList") as! [Date]
        subject = lecture.object(forKey: "subject") as! String
        subjectName = vc.transformSubject(subject)
        detail = lecture.object(forKey: "detail") as? String ?? ""
        
        let studentId = ncmb.object(forKey: "studentId") as! String
        
        let teacherId = ncmb.object(forKey: "teacherId") as! String
        isAbleToEdit = teacherId == currentUserG.userId
        
        let query1 = NCMBQuery(className: "TeacherParameter")
        query1?.whereKey("userId", equalTo: teacherId)
        let result1 = try? query1?.findObjects()
        if result1 == nil{
            vc.showOkAlert(title: "Error", message: "教師が見つかりませんでした。")
        } else{
            let object = result1?.first as? NCMBObject
            if object == nil{
                vc.showOkAlert(title: "Error", message: "教師が見つかりませんでした。")
            } else{
                self.teacher = User(userId: teacherId, isNeedParameter: false, viewController: vc)
                let _ = TeacherParameter(object!, user: &self.teacher!)
            }
        }
        
        let query2 = NCMBQuery(className: "StudentParameter")
        query2?.whereKey("userId", equalTo: studentId)
        let result2 = try? query2?.findObjects()
        if result2 == nil{
            vc.showOkAlert(title: "Error", message: "生徒が見つかりませんでした。")
        } else{
            let object = result2?.first as? NCMBObject
            if object == nil{
                vc.showOkAlert(title: "Error", message: "生徒が見つかりませんでした。")
            } else{
                self.student = User(userId: teacherId, isNeedParameter: false, viewController: vc)
                let _ = StudentParameter(object!, user: &self.student!)
            }
        }
    }
    
//    初回登録用
    init(student: User, timeList: [Date], subject: String, detail: String, _ vc: UIViewController){
        isAbleToEdit = true
        ncmb = NCMBObject(className: "Lecture")!
        teacher = currentUserG
        ncmb.setObject(teacher!.userId, forKey: "teacherId")
        self.student = student
        
        ncmb.setObject(student.userId, forKey: "studentId")
        let startTime = timeList.first!
        ncmb.setObject(startTime, forKey: "startTime")
        let endTime = timeList.last!
        ncmb.setObject(endTime, forKey: "endTime")
        self.timeList = timeList
        ncmb.setObject(timeList, forKey: "timeList")
        
        self.subject = subject
        self.subjectName = vc.transformSubject(subject)
        
        self.detail = detail
        ncmb.setObject(detail, forKey: "detail")
        
        ncmb.setObject(subject, forKey: "subject")
        ncmb.setObject(0, forKey: "teacherAttendanceTime")
        ncmb.setObject(0, forKey: "studentAttendanceTime")
        ncmb.saveInBackground { error in
            if error == nil{
                self.delegate?.savedLecture()
            } else{
                vc.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
}

//コマ生成用
extension Lecture{
    func timeFrame(date: Date) -> [TimeFrameUnit]{
        var ret = [TimeFrameUnit]()
        let c = Calendar(identifier: .gregorian)
        let tomorrow = c.date(byAdding: .day, value: 1, to: date)!
        for time in self.timeList{
            if date <= time && time < tomorrow && self.teacher != nil && self.student != nil{
//                コピペ時注意＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
                let t = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: self.teacher!.userId == currentUserG.userId)
                t.lectureId = self.ncmb.objectId
                t.eventType = "telecture"
                ret.append(t)
            }
        }
        return ret
    }
}
