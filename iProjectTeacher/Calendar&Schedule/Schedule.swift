//
//  Schedule.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/03.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB

class Schedule{
    
    var ncmb: NCMBObject
    
    var title: String
    var detail: String
    var eventType: String
    
    var isAbleToShow: Bool
    
    var student: User
    var teacher: User
    
    var detailTimeList: [[Date]]
    
    init(schedule: NCMBObject, _ vc: UIViewController) {
        ncmb = schedule
        
        title = schedule.object(forKey: "title") as! String
        detail = schedule.object(forKey: "detail") as? String ?? ""
        eventType = schedule.object(forKey: "eventType") as! String
        
        let studentId = schedule.object(forKey: "studentId") as! String
        student = User(userId: studentId, isNeedParameter: true, viewController: vc)
        let teacherId = schedule.object(forKey: "teacherId") as! String
        teacher = User(userId: teacherId, isNeedParameter: true, viewController: vc)
        let iATS = schedule.object(forKey: "isAbleToShow") as! Bool
//        コピペ時注意＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
        isAbleToShow = teacherId == currentUserG.userId || iATS
        
        detailTimeList = schedule.object(forKey: "detailTimeList") as! [[Date]]
    }
    
    init(title: String, detail: String, eventType: String, student: User, detailTimeList: [[Date]], _ vc: UIViewController){
        ncmb = NCMBObject(className: "Schedule")!
        
        self.title = title
        ncmb.setObject(title, forKey: "title")
        self.detail = detail
        ncmb.setObject(detail, forKey: "detail")
        self.eventType = eventType
        ncmb.setObject(eventType, forKey: "eventType")
        
        self.student = student
        ncmb.setObject(student.userId, forKey: "studentId")
        self.teacher = currentUserG
        ncmb.setObject(teacher.userId, forKey: "teacherId")
        
        isAbleToShow = true
        
        self.detailTimeList = detailTimeList
        ncmb.setObject(detailTimeList, forKey: "detailTimeList")
        ncmb.setObject(detailTimeList.first?.first , forKey: "startTime")
        ncmb.setObject(detailTimeList.last?.last , forKey: "endTime")
        if detailTimeList.count != 0{
            for detailTime in detailTimeList{
                if(detailTime.count != 2){
                    return
                }
                if(detailTime[0] >= detailTime[1]){
                    return
                }
            }
            ncmb.saveInBackground { error in
                if error != nil{
                    vc.showOkAlert(title: "Saving message error!", message: error!.localizedDescription)
                }
            }
        }
    }
}

//コマ生成用
extension Schedule{
    func timeFrame(date: Date) -> [TimeFrameUnit]{
        var ret = [TimeFrameUnit]()
        let c = Calendar(identifier: .gregorian)
        let tomorrow = c.date(byAdding: .day, value: 1, to: date)!
        for times in self.detailTimeList{
            if(times[0] < tomorrow || times[1] >= date){
                var startTime = businessHoursG[date.weekId].first
                var startMinute = 0
                var endTime = businessHoursG[date.weekId].last
                var endMinute = 0
                if (date <= times[0] && times[0] < tomorrow) {
                    let sTime = times[0].h
                    startMinute = times[0].min
                    startTime = max(startTime, sTime)
                }
                if (date <= times[1] && times[1] < tomorrow) {
                    var eTime = times[1].h
                    if times[1].min != 0{
                        eTime += 1
                        endMinute = times[1].min
                    }
                    endTime = min(endTime, eTime)
                }
                if(startTime < endTime){
                    for i in startTime..<endTime{
//                        コピペ時注意＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
                        let t = TimeFrameUnit(time: i, title: self.title, isAbleToShow: self.isAbleToShow, isMyEvent: teacher.userId == currentUserG.userId)
                        t.firstTime = t.time + startMinute
                        t.lastTime = t.time + endMinute
                        t.scheduleId = self.ncmb.objectId
                        t.eventType = self.eventType
                        ret.append(t)
                    }
                }
            }
        }
        return ret
    }
}
