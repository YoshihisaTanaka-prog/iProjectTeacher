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
    var student: User
    var teacher: User
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
//        コピペ時注意
        isAbleToEdit = teacherId == currentUserG.userId
        
        teacher = User(userId: teacherId, isNeedParameter: true, viewController: vc)
        student = User(userId: studentId, isNeedParameter: true, viewController: vc)
    }
    
//    初回登録用
    init(student: User, timeList: [Date], subject: String, detail: String, _ vc: UIViewController){
        isAbleToEdit = true
        ncmb = NCMBObject(className: "Lecture")!
        teacher = currentUserG
        ncmb.setObject(teacher.userId, forKey: "teacherId")
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
    func timeFrame(date: Date, studentId: String) -> [String: [TimeFrameUnit]]{
        var ret = [String:[TimeFrameUnit]]()
        let c = Calendar(identifier: .gregorian)
        let firstDate = c.date(from: DateComponents(year: date.y, month: date.m, day: 1))!
        let lastDate = c.date(from: DateComponents(year: date.y, month: date.m + 1, day: 1))!
        print(self.subjectName)
        for time in self.timeList{
            if firstDate <= time && time < lastDate {
                if ret[time.d.s] == nil{
                    ret[time.d.s] = []
                }
//                コピペ時注意＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
                print(time.m, time.d, time.h)
                if self.teacher.userId == currentUserG.userId && self.student.userId == studentId {
                    let t1 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: true)
                    t1.lectureId = self.ncmb.objectId
                    t1.eventType = "telecture"
                    ret[time.d.s]!.append(t1)
                    let t2 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: false)
                    t2.lectureId = self.ncmb.objectId
                    t2.eventType = "telecture"
                    ret[time.d.s]!.append(t2)
                } else if self.teacher.userId == currentUserG.userId {
                    let t1 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: true)
                    t1.lectureId = self.ncmb.objectId
                    t1.eventType = "telecture"
                    ret[time.d.s]!.append(t1)
                } else{
                    let t2 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: false)
                    t2.lectureId = self.ncmb.objectId
                    t2.eventType = "telecture"
                    ret[time.d.s]!.append(t2)
                }
            }
        }
        return ret
    }
}


class LectureTimeObject{
    let id: String
    let startTime: Date
    let endTime: Date
    init(id: String, startTime: Date){
        self.id = id
        self.startTime = startTime
        let c = Calendar(identifier: .gregorian)
        endTime = c.date(from: DateComponents(year: startTime.y, month: startTime.m, day: startTime.d, hour: startTime.h + 1, minute: startTime.min))!
    }
}
