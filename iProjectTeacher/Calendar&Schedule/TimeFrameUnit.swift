//
//  TimeFrameUnit.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/03.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation

class TimeFrameUnit{
    var time: Int
    var firstTime: Int
    var lastTime: Int
    var isAbleToShow: Bool
    var isMyEvent: Bool
    var title: String
    var eventType: String!
    var lectureId: String?
    var scheduleIds = [String]()
    
    init(time: Int, isMyEvent: Bool, shiftTimes: [Int]) {
        self.time = time * 100
        self.firstTime = time * 100
        self.lastTime = time * 100 + 100
        if shiftTimes.contains(time){
            self.title = "空きコマ"
            self.eventType = "free"
        } else{
            self.title = "-----"
            self.eventType = "non"
        }
        self.isAbleToShow = false
        self.isMyEvent = isMyEvent
    }
    
    init(time: Int, title: String, isAbleToShow: Bool, isMyEvent: Bool){
        self.time = time * 100
        self.firstTime = time * 100
        self.lastTime = time * 100 + 100
        self.title = title
        self.isAbleToShow = isAbleToShow
        self.isMyEvent = isMyEvent
    }
    init(firstHour: Int, firstMinute: Int, lastHour: Int, lastMinute: Int, title: String, isAbleToShow: Bool, isMyEvent: Bool){
        self.time = firstHour * 100
        self.firstTime = firstHour * 100 + firstMinute
        self.lastTime = lastHour * 100 + lastMinute
        self.title = title
        self.isAbleToShow = isAbleToShow
        self.isMyEvent = isMyEvent
    }
}

class TimeFrame{
    var firstTime: Int
    var lastTime: Int
    var title: String
    var eventType: String
    var lectureId: String?
    var scheduleIds = [String]()
    init(firstTime: Date, lastTime: Date, title: String, eventType: String){
        self.firstTime = firstTime.h * 100 + firstTime.m
        self.lastTime = lastTime.h * 100 + lastTime.m
        self.title = title
        self.eventType = eventType
    }
}
