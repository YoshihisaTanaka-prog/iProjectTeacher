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

class Schedules {
    var monthDic = [String: ScheduleMonth]()

    func loadSchedule(date: Date, userIds: [String], _ vc: UIViewController){
        load(date: date, userIds: userIds, vc)
        for i in 1...3{
            let pd = Calendar.current.date(byAdding: .month, value: i, to: date)!
            let md = Calendar.current.date(byAdding: .month, value: -i, to: date)!
            load(date: pd, userIds: userIds, vc)
            load(date: md, userIds: userIds, vc)
        }
    }
    
    func isExistsSchedule(date: Date) -> Bool{
        let ym = date.y.s + date.m.s02
        let d = date.d.s
        return !(self.monthDic[ym]?.dateDic[d] == nil)
    }
    func isExistsSchedule(date: Date, time: Int) -> Bool{
        let ym = date.y.s + date.m.s02
        let d = date.d.s
        if self.monthDic[ym]?.dateDic[d] == nil{
            return false
        }
        let dic = self.monthDic[ym]!.dateDic[d]!
        for t in dic{
            if t.time == time{
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
        if(self.monthDic[ym]?.dateDic[d] == nil){
            for i in businessHoursG[date.weekId].first..<businessHoursG[date.weekId].last{
                var tfus = [TimeFrameUnit]()
                for j in 0...1{
                    tfus.append(TimeFrameUnit(time: i, isMyEvent: j == 0))
                }
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
                                if timeFrameList[k].isMyEvent {
                                    tfus.append(timeFrameList[k])
                                    k += 1
                                } else{
                                    tfus.append( TimeFrameUnit(time: i, isMyEvent: false) )
                                }
                            } else{
                                tfus.append( TimeFrameUnit(time: i, isMyEvent: false) )
                            }
                        } else{
                            tfus.append( TimeFrameUnit(time: i, isMyEvent: true) )
                            tfus.append(timeFrameList[k])
                            k += 1
                        }
                    } else{
                        for j in 0...1{
                            tfus.append(TimeFrameUnit(time: i, isMyEvent: j == 0))
                        }
                    }
                } else{
//                    予定が終わったら空きコマのみ追加
                    for j in 0...1{
                        tfus.append(TimeFrameUnit(time: i, isMyEvent: j == 0))
                    }
                }
                ret.append(tfus)
            }
            return ret
        }
    }

    private func load(date: Date, userIds: [String], _ vc: UIViewController){
        let ym = date.y.s + date.m.s02
        if self.monthDic[ym] == nil{
            self.monthDic[ym] = ScheduleMonth()
        }
        self.monthDic[ym]?.loadSchedule(date: date, userIds: userIds, vc)
    }
}

class ScheduleMonth {
    var dateDic = [String: [TimeFrameUnit]]()
    
    func loadSchedule(date: Date, userIds: [String], _ vc: UIViewController){
        let calendar = Calendar(identifier: .gregorian)
        let startDay = calendar.date(from: DateComponents(year: date.y, month: date.m, day: 1))
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: date)!
        let endDay = calendar.date(from: DateComponents(year: nextMonth.y, month: nextMonth.m, day: 1))
        
        let scheduleQuery1 = query(className: "Schedule", userIds: userIds)
        scheduleQuery1.whereKey("endTime", greaterThanOrEqualTo: startDay)
        let scheduleQuery2 = NCMBQuery(className: "Schedule")!
        scheduleQuery2.whereKey("startTime", lessThan: endDay)
        let scheduleQuery = NCMBQuery.orQuery(withSubqueries: [scheduleQuery1,scheduleQuery2])
        scheduleQuery?.findObjectsInBackground({ result, error in
            if error == nil{
                self.dateDic.removeAll()
//                ここに普通のスケジュールを追加するための処理を書く
                let objects = result as! [NCMBObject]
                for o in objects{
                    let schedule = Schedule(schedule: o, vc)
                    cachedScheduleG[o.objectId] = schedule
                    for i in 0..<startDay!.maxDate{
                        let day = calendar.date(byAdding: .day, value: i, to: startDay!)!
                        let d = day.d.s
                        if self.dateDic[d] == nil{
                            self.dateDic[d] = schedule.timeFrame(date: day)
                        } else{
                            self.dateDic[d]! += schedule.timeFrame(date: day)
                        }
                    }
                }
                self.sort()
                
                let lectureQuery1 = self.query(className: "Lecture", userIds: userIds)
                lectureQuery1.whereKey("endTime", greaterThanOrEqualTo: startDay)
                let lectureQuery2 = self.query(className: "Lecture", userIds: userIds)
                lectureQuery2.whereKey("startTime", lessThan: endDay)
                let lectureQuery = NCMBQuery.orQuery(withSubqueries: [lectureQuery1, lectureQuery2])
                lectureQuery?.findObjectsInBackground { result, error in
                    if error == nil{
                        let objects = result as! [NCMBObject]
                        for o in objects{
                            let lecture = Lecture(lecture: o, vc)
                            cachedLectureG[o.objectId] = lecture
                            for i in 0..<startDay!.maxDate{
                                let day = calendar.date(byAdding: .day, value: i, to: startDay!)!
                                let d = day.d.s
                                if self.dateDic[d] == nil{
                                    self.dateDic[d] = lecture.timeFrame(date: day)
                                } else{
                                    self.dateDic[d]! += lecture.timeFrame(date: day)
                                }
                            }
                        }
                        self.sort()
                    } else {
                        vc.showOkAlert(title: "Loading telecture class schedule error!", message: error!.localizedDescription)
                    }
                }
            } else {
                vc.showOkAlert(title: "Loading schedule error!", message: error!.localizedDescription)
            }
        })
    }
    
    private func query(className: String, userIds: [String]) -> NCMBQuery {
        var queries = [NCMBQuery]()
        for u in userIds{
            let tq = NCMBQuery(className: className)!
            tq.whereKey(u, equalTo: "teacherId")
            let sq = NCMBQuery(className: className)!
            sq.whereKey(u, equalTo: "studentId")
            queries.append(tq)
            queries.append(sq)
        }
        return NCMBQuery.orQuery(withSubqueries: queries)
    }
    
    private func sort(){
        for value in self.dateDic.values{
            var v = value
            v.sort(by: {$0.time < $1.time})
            if v.count != 0{
                for i in 0..<( v.count - 1 ){
                    if v[i].time == v[i+1].time && !v[i].isMyEvent {
                        let u = v[i]
                        v[i] = v[i+1]
                        v[i+1] = u
                    }
                }
            }
        }
    }
}
