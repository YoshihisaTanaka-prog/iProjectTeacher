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
    var scheduleId: String?
    
    init(time: Int, isMyEvent: Bool) {
        self.time = time * 100
        self.firstTime = time * 100
        self.lastTime = time + 100
        self.title = "空きコマ"
        self.eventType = "non"
        self.isAbleToShow = false
        self.isMyEvent = isMyEvent
    }
    
    init(time: Int, title: String, isAbleToShow: Bool, isMyEvent: Bool){
        self.time = time * 100
        self.firstTime = time * 100
        self.lastTime = time + 100
        self.title = title
        self.isAbleToShow = isAbleToShow
        self.isMyEvent = isMyEvent
    }
}
