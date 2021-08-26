//
//  OriginalTabBarController.swift
//  iProjectTeacher
//
//  Created by Kaori Nakamura on 8/12/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class OriginalTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChatRoom()
        loadFollowList()
        myScheduleG.loadSchedule(date: Date(), userIds: [currentUserG.userId], UIViewController())
        
        getTodaysLectureTimeList()
        
//        基本的に1分ごとに判定するが、最初が00秒とは限らないので00秒ごとに判定させるように計算する。
        let d = Date()
        timeIntervalG = (59 - d.s).d + (1000000000 - d.ns).d / 1000000000.d
        if timeIntervalG == 0.0{
            timeIntervalG = 60.d
        }
        startTimer()
    }

    private func startTimer(){
        if isAbleToStartTimerG{
            lectureCheckTimerG = Timer.scheduledTimer(timeInterval: TimeInterval(timeIntervalG), target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            isAbleToStartTimerG = false
        }
    }
    
    @objc private func updateTimer(){
//        1分ごとに判定するように修正
        if timeIntervalG != 60.d{
            stopLectureTimer()
            timeIntervalG = 60.d
            startTimer()
        }
//        授業中かどうか判定し、授業中なら画面遷移
        judgeIsNeedToGoLecturePage()
    }
}
