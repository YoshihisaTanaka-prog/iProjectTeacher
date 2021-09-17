//
//  ScheduleObject.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/03.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB
import CalculateCalendarLogic

protocol ScheduleDelegate {
    func schedulesDidLoaded()
    func allSchedulesDidLoaded()
}

protocol ScheduleMonthDelegate {
    func schedulesDidLoaded(date: Date)
}

class Schedules: ScheduleMonthDelegate {
    
    var delegate: ScheduleDelegate?
    var monthDic = [String: ScheduleMonth]()
    private var dateList = [Date]()
    private var index = 0
    private var userIds = [String]()
    private var vc: UIViewController!

    func loadSchedule(date: Date, userIds: [String], _ vc: UIViewController){
        self.userIds = userIds
        
        if userIds.count == 2{
            if userIds[0] != currentUserG.userId{
                let ui = userIds[0]
                self.userIds[0] = userIds[1]
                self.userIds[1] = ui
            }
        }
        
        self.vc = vc
        delete()
        dateList = []
        dateList.append(date)
        load(date: date, userIds: userIds, vc)
        for i in 1...2{
            let pd = Calendar.current.date(byAdding: .month, value: i, to: date)!
            let md = Calendar.current.date(byAdding: .month, value: -i, to: date)!
            dateList.append(pd)
            dateList.append(md)
        }
    }
    
    func isExistsSchedule(date: Date) -> Bool{
        let ym = date.y.s + date.m.s02
        let d = date.d.s
        if self.monthDic[ym]?.dateDic[d] == nil {
            return false
        }
        if self.monthDic[ym]!.dateDic[d]!.count == 0 {
            return false
        }
        return true
    }
    func isExistsSchedule(date: Date, time: Int) -> Bool{
        let ym = date.y.s + date.m.s02
        let d = date.d.s
        if self.monthDic[ym]?.dateDic[d] == nil{
            return false
        }
        let dic = self.monthDic[ym]!.dateDic[d]!
        for t in dic{
            if t.time == time * 100{
                return true
            }
        }
        return false
    }
    
    func delete() {
        for v in self.monthDic.values{
            v.dateDic.removeAll()
        }
        self.monthDic.removeAll()
    }
    
    func searchSchedule(date: Date, time: Int) -> [TimeFrameUnit] {
        let ym = date.y.s + date.m.s02
        let d = date.d.s
        if self.monthDic[ym]?.dateDic[d] == nil{
            return []
        }
        let dic = self.monthDic[ym]!.dateDic[d]!
        var ret = [TimeFrameUnit]()
        for t in dic{
            if t.time == time{
                ret.append(t)
            }
        }
        return ret
    }
    
    func showTimeFrame(date: Date) -> [[TimeFrameUnit]] {
        var ret = [[TimeFrameUnit]]()
        let ym = date.y.s + date.m.s02
        let d = date.d.s
        
        var teacherTimeList = [Int]()
        for s in currentUserG.youbiTimeList[date.weekId]{
            let list = s.split(separator: ":")
            teacherTimeList.append(Int(list.first!)!)
        }
        var studentId = ""
        for u in userIds{
            if u != currentUserG.userId{
                studentId = u
            }
        }
        var studentTimeList = [Int]()
        var student = User(userId: "", isNeedParameter: false, viewController: vc)
        if studentId != "" {
            let students = vc.mixFollowList()
            for s in students{
                if s.userId == studentId{
                    student = s
                    for ytl in student.youbiTimeList[date.weekId]{
                        let list = ytl.split(separator: ":")
                        studentTimeList.append(Int(list.first ?? "0") ?? 0)
                    }
                    break
                }
            }
        }
        
        if(self.monthDic[ym]?.dateDic[d] == nil || self.monthDic[ym]!.dateDic[d]!.count == 0){
            for i in businessHoursG[date.weekId].first..<businessHoursG[date.weekId].last{
                var tfus = [TimeFrameUnit]()
                tfus.append(TimeFrameUnit(time: i, isMyEvent: true, shiftTimes: teacherTimeList))
                tfus.append(TimeFrameUnit(time: i, isMyEvent: false, shiftTimes: studentTimeList))
                ret.append(tfus)
            }
            return ret
        } else{
            let timeFrameList = self.monthDic[ym]!.dateDic[d]!
            var k = 0
            for i in businessHoursG[date.weekId].first..<businessHoursG[date.weekId].last{
                var tfus = [TimeFrameUnit]()
                if k < timeFrameList.count {
//                    予定が終わっていない場合
                    if timeFrameList[k].time == i * 100 {
//                        予定時刻の場合
                        if timeFrameList[k].isMyEvent {
                            tfus.append(timeFrameList[k])
                            k += 1
                            if k < timeFrameList.count{
                                if timeFrameList[k].time == i * 100{
                                    tfus.append(timeFrameList[k])
                                    k += 1
                                } else{
                                    tfus.append( TimeFrameUnit(time: i, isMyEvent: false, shiftTimes: studentTimeList) )
                                }
                            } else{
                                tfus.append( TimeFrameUnit(time: i, isMyEvent: false, shiftTimes: studentTimeList) )
                            }
                        } else{
                            tfus.append( TimeFrameUnit(time: i, isMyEvent: true, shiftTimes: teacherTimeList) )
                            tfus.append(timeFrameList[k])
                            k += 1
                        }
                        while k < timeFrameList.count && timeFrameList[k].time == i * 100 {
                            k += 1
                        }
                    } else{
                        tfus.append(TimeFrameUnit(time: i, isMyEvent: true, shiftTimes: teacherTimeList))
                        tfus.append(TimeFrameUnit(time: i, isMyEvent: false, shiftTimes: studentTimeList))
                    }
                } else{
//                    予定が終わったら空きコマのみ追加
                    tfus.append(TimeFrameUnit(time: i, isMyEvent: true, shiftTimes: teacherTimeList))
                    tfus.append(TimeFrameUnit(time: i, isMyEvent: false, shiftTimes: studentTimeList))
                }
                ret.append(tfus)
            }
            return ret
        }
    }

    private func load(date: Date, userIds: [String], _ vc: UIViewController){
        let ym = date.y.s + date.m.s02
        if self.monthDic[ym] == nil{
            self.monthDic[ym] = ScheduleMonth(date: date)
        }
        self.monthDic[ym]?.delegate = self
        self.monthDic[ym]?.loadSchedule(date: date, userIds: userIds, vc)
    }
    
    func schedulesDidLoaded(date: Date) {
        if index == 0 {
            self.delegate?.schedulesDidLoaded()
            getTodaysLectureTimeList()
            judgeIsNeedToGoLecturePage()
        }
        index += 1
        if index >= dateList.count{
            self.delegate?.allSchedulesDidLoaded()
            index = 0
        } else{
            load(date: dateList[index], userIds: userIds, vc)
        }
    }
}

class ScheduleMonth {
    var delegate: ScheduleMonthDelegate?
    var dateDic = [String: [TimeFrameUnit]]()
    private let startDay: Date!
    
    init(date: Date) {
        let c = Calendar(identifier: .gregorian)
        startDay = c.date(from: DateComponents(year: date.y, month: date.m, day: 1))!
    }
    
    func loadSchedule(date: Date, userIds: [String], _ vc: UIViewController){
        let calendar = Calendar(identifier: .gregorian)
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: date)!
        let endDay = calendar.date(from: DateComponents(year: nextMonth.y, month: nextMonth.m, day: 1))!
        
        let scheduleQuery = NCMBQuery(className: "Schedule")!
        scheduleQuery.whereKey("userId", containedIn: userIds)
        scheduleQuery.whereKey("endTime", greaterThanOrEqualTo: startDay)
        scheduleQuery.whereKey("startTime", lessThan: endDay)
        scheduleQuery.findObjectsInBackground({ result, error in
            if error == nil{
//                self.dateDic.removeAll()
                let objects = result as! [NCMBObject]
                for o in objects{
                    let schedule = Schedule(schedule: o, vc)
                    cachedScheduleG[o.objectId] = schedule
                    let timeFrameDic = schedule.timeFrame(date: self.startDay)
                    for i in 1...self.startDay.maxDate{
                        let d = i.s
                        if self.dateDic[d] == nil{
                            self.dateDic[d] = []
                        }
                        self.dateDic[d]! += timeFrameDic[d] ?? []
                    }
                }
                self.scheduleSort()
                DispatchQueue.main.async {
                    let lectureQuery = self.query(className: "Lecture", userIds: userIds)
                    if reportedDataG["User"] != nil && reportedDataG["User"] != [] {
                        lectureQuery.whereKey("studentId", notContainedIn: reportedDataG["User"]!)
                    }
                    lectureQuery.whereKey("startTime", greaterThanOrEqualTo: self.startDay)
                    lectureQuery.whereKey("startTime", lessThan: endDay)
                    lectureQuery.findObjectsInBackground { result, error in
                        if error == nil{
                            let objects = result as! [NCMBObject]
                            for o in objects{
                                if let lecture = Lecture(lecture: o, vc){
                                    cachedLectureG[o.objectId] = lecture
    //                                ここのループをもっと上手くすること。
                                    let timeFrameDic = lecture.timeFrame(date: self.startDay, studentId: userIds.last!)
                                    for i in 0..<self.startDay.maxDate{
                                        let d = (i+1).s
                                        if self.dateDic[d] == nil{
                                            self.dateDic[d] = []
                                        }
                                        self.dateDic[d]! += timeFrameDic[d] ?? []
                                    }
                                }
                            }
                            self.lectureSort()
                            self.delegate?.schedulesDidLoaded(date: self.startDay)
                        } else {
                            print("Loading telecture class schedule error!", error!.localizedDescription)
                            vc.showOkAlert(title: "Loading telecture class schedule error!", message: error!.localizedDescription)
                        }
                    }
                }
            } else {
                print("Loading schedule error!", error!.localizedDescription)
                vc.showOkAlert(title: "Loading schedule error!", message: error!.localizedDescription)
            }
        })
    }
    
    private func query(className: String, userIds: [String]) -> NCMBQuery {
        var queries = [NCMBQuery]()
        let tq = NCMBQuery(className: className)!
        tq.whereKey("teacherId", containedIn: userIds)
        let sq = NCMBQuery(className: className)!
        sq.whereKey("studentId", containedIn: userIds)
        queries.append(tq)
        queries.append(sq)
        return NCMBQuery.orQuery(withSubqueries: queries)
    }
    
    private func scheduleSort(){
        for (key, value) in self.dateDic{
            var v = value
            v = v.sorted { a, b in
                if a.time == b.time{
                    return a.firstTime < b.firstTime
                } else{
                    return a.time < b.time
                }
            }
            var i = 0
            var length = v.count - 1
            while i < length{
                if v[i].time == v[i+1].time {
                    v[i].lastTime = v[i+1].lastTime
                    v[i].title += "/" + v[i+1].title
                    v.remove(at: i+1)
                    length -= 1
                }
                i += 1
            }
            self.dateDic[key] = v
        }
    }
    
    private func lectureSort(){
        for (key, value) in self.dateDic{
            var v = value
            v = v.sorted { a, b in
                if a.time == b.time{
//                    ＊＊＊＊＊＊＊＊＊＊コピペ時注意＊＊＊＊＊＊＊＊＊＊＊
                    if a.isMyEvent || b.isMyEvent {
                        return a.isMyEvent
                    } else{
                        return a.lectureId != nil
                    }
                } else {
                    return a.time < b.time
                }
            }
            self.dateDic[key] = v
        }
    }
}
