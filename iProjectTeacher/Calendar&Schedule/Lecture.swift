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
    
    var objectId: String
    var lecturesId: String
    var student: User
    var teacher: User
    var startTime: Date
    var isFinished: Bool
    var subject: String
    var subjectName: String
    var detail: String
    var teacherAttendanceTime: Int
    var studentAttendanceTime: Int
    var isAbleToEdit: Bool
    var reportId: String?
    var reviewId: String?
    
//    読み取り用
    init?(lecture: NCMBObject, _ vc: UIViewController){
        if lecture.ncmbClassName != "Lecture"{
            return nil
        }
        objectId = lecture.objectId
        lecturesId = lecture.object(forKey: "lecturesId") as? String ?? ""
        startTime = lecture.object(forKey: "startTime") as! Date
        isFinished = lecture.object(forKey: "isFinished") as? Bool ?? false
        subject = lecture.object(forKey: "subject") as! String
        subjectName = vc.transformSubject(subject)
        detail = lecture.object(forKey: "detail") as? String ?? ""
        
        let studentId = lecture.object(forKey: "studentId") as! String
        
        let teacherId = lecture.object(forKey: "teacherId") as! String
//        コピペ時注意
        isAbleToEdit = teacherId == currentUserG.userId
        
        teacher = User(userId: teacherId, isNeedParameter: true, viewController: vc)
        student = User(userId: studentId, isNeedParameter: true, viewController: vc)
        
        teacherAttendanceTime = lecture.object(forKey: "teacherAttendanceTime") as? Int ?? 0
        studentAttendanceTime = lecture.object(forKey: "studentAttendanceTime") as? Int ?? 0
        
        reportId = lecture.object(forKey: "reportId") as? String
        reviewId = lecture.object(forKey: "reviewId") as? String
        
        lecturesId = lecture.object(forKey: "lecturesId") as? String ?? ""
        if cachedLecturesG[lecturesId] == nil{
            cachedLecturesG[lecturesId] = Lectures(id: lecturesId)
        }
        cachedLecturesG[lecturesId]!.addLectureId(lectureId: self.objectId, time: self.startTime)
    }
    
//    初回登録用
    init(id: String?, student: User, startTime: Date, subject: String, detail: String, lecturesId: String, _ vc: UIViewController){
        isAbleToEdit = true
        objectId = id ?? ""
        let ncmb = NCMBObject(className: "Lecture", objectId: id)!
        self.lecturesId = lecturesId
        ncmb.setObject(lecturesId, forKey: "lecturesId")
        isFinished = false
        ncmb.setObject(isFinished, forKey: "isFinished")
        teacher = currentUserG
        ncmb.setObject(teacher.userId, forKey: "teacherId")
        self.student = student
        
        ncmb.setObject(student.userId, forKey: "studentId")
        self.startTime = startTime
        ncmb.setObject(startTime, forKey: "startTime")
        
        self.subject = subject
        self.subjectName = vc.transformSubject(subject)
        
        self.detail = detail
        ncmb.setObject(detail, forKey: "detail")
        
        ncmb.setObject(subject, forKey: "subject")
        teacherAttendanceTime = 0
        studentAttendanceTime = 0
        ncmb.setObject(nil, forKey: "studentPeerId")
        ncmb.setObject(nil, forKey: "reportId")
        ncmb.setObject(nil, forKey: "reviewId")
        ncmb.saveInBackground { error in
            if error == nil{
                self.objectId = ncmb.objectId
                if cachedLecturesG[lecturesId] == nil{
                    cachedLecturesG[lecturesId] = Lectures(id: lecturesId)
                }
                cachedLecturesG[lecturesId]!.addLectureId(lectureId: self.objectId, time: self.startTime)
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
        let time = self.startTime
        if firstDate <= time && time < lastDate {
            if ret[time.d.s] == nil{
                ret[time.d.s] = []
            }
//                コピペ時注意＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
            print(time.m, time.d, time.h)
            if self.teacher.userId == currentUserG.userId && self.student.userId == studentId {
                let t1 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: true)
                t1.lectureId = self.objectId
                t1.eventType = "telecture"
                ret[time.d.s]!.append(t1)
                let t2 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: false)
                t2.lectureId = self.objectId
                t2.eventType = "telecture"
                ret[time.d.s]!.append(t2)
            } else if self.teacher.userId == currentUserG.userId {
                let t1 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: true)
                t1.lectureId = self.objectId
                t1.eventType = "telecture"
                ret[time.d.s]!.append(t1)
            } else{
                let t2 = TimeFrameUnit(time: time.h, title: self.subjectName, isAbleToShow: true, isMyEvent: false)
                t2.lectureId = self.objectId
                t2.eventType = "telecture"
                ret[time.d.s]!.append(t2)
            }
        }
        
        return ret
    }
}

class Lectures{
    var objectId: String
    var lectuerIds = [String]()
    
    init(id: String){
        objectId = id
    }
    
    func addLectureId(lectureId: String, time: Date) {
        if !self.lectuerIds.contains(lectureId){
            if self.lectuerIds.count != 0 {
                for i in 0..<self.lectuerIds.count{
                    if let lec = cachedLectureG[self.lectuerIds[i]]{
                        if lec.startTime > time{
                            self.lectuerIds.insert(lectureId, at: i)
                            return
                        }
                    }
                }
            }
            self.lectuerIds.append(lectureId)
        }
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
