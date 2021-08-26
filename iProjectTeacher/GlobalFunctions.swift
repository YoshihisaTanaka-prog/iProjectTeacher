//
//  GlobalFunctions.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/08/17.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

//今日の授業の時間のデータを取得するための関数
func getTodaysLectureTimeList(){
    let c = Calendar(identifier: .gregorian)
    lectureTimeListG = []
    for l in cachedLectureG.values{
//            教師用へのコピペ時注意＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
        if l.teacher.userId == currentUserG.userId{
            for t in l.timeList{
                if c.isDateInToday(t) && c.date(from: DateComponents(year: t.y, month: t.m, day: t.d, hour: t.h+1, minute: t.min))! >= Date(){
                    lectureTimeListG.append(LectureTimeObject(id: l.ncmb.objectId, startTime: t))
                }
            }
        }
    }
    lectureTimeListG.sort{ $0.startTime > $1.startTime }
    print(lectureTimeListG.count)
}

func judgeIsNeedToGoLecturePage(){
    let c = Calendar(identifier: .gregorian)
    if !c.isDateInToday(today){
        today = Date()
        getTodaysLectureTimeList()
    }
    let now = Date()
    let checkTime1 = c.date(byAdding: .minute, value: -5, to: now)!
    for lt in lectureTimeListG{
        if(lt.startTime <= checkTime1 && now <= lt.endTime ){
//                タイマーを止める
            stopLectureTimer()
            
//                画面遷移＆値渡し
            let storyboard = UIStoryboard(name: "Lecture", bundle: Bundle.main)
            let nextVC = storyboard.instantiateViewController(identifier: "LectureViewController") as! LectureViewController
            nextVC.lecture = cachedLectureG[lt.id]!
            currentVC?.present(nextVC, animated: true, completion: nil)
            
//                ループ終了
            break
        }
    }
}

func stopLectureTimer(){
    lectureCheckTimerG?.invalidate()
    isAbleToStartTimerG = true
}
