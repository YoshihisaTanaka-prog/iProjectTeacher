//
//  Global.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/02/16.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit

//  あくまで背景が勝手に決めたルールですが、グローバル変数は便利な反面ミスが発生しやすくなるので、名前の最後にGをつけておいてください。

var screenSizeG: Dictionary<String, Size> = [:]
let dColor = OriginalCollor()
var isLogInG: Bool = false
var currentUserG: User!
var reportedDataG = [String:[String]]()

var followUserListG: [User] = []
var waitingUserListG: [User] = []
var favoriteUserListG: [User] = []

let eventTypeRankG: [String: Int] = ["non": 0, "hope": 1, "telecture": 2, "private": 3, "school": 4]
var cachedScheduleG = [String: Schedule]()
var cachedLectureG = [String: Lecture]()
var cachedLecturesG = [String: Lectures]()
var myScheduleG = Schedules()
var mixedScheduleG = Schedules()

//railsとの連携に必要な定数
let token = "fN4BnkumjMvnbZd47gFLYL7JpVn283eaZwxEpT8NYyhYMPUaRDzR3dQZxTUT2eQYz7gqG9UMjAm8VaM26fhH7ueN7fJbXPsfCpM8"

//営業時間を設定するための変数
let businessHoursG = [
    TimeRange(first: 16, last: 22), // 月曜日の営業時間
    TimeRange(first: 16, last: 22), // 火曜日の営業時間
    TimeRange(first: 16, last: 22), // 水曜日の営業時間
    TimeRange(first: 16, last: 22), // 木曜日の営業時間
    TimeRange(first: 16, last: 22), // 金曜日の営業時間
    TimeRange(first: 9, last: 22),  // 土曜日の営業時間
    TimeRange(first: 9, last: 22)   // 日曜日・祝日の営業時間
]

//授業ページに自動遷移するための変数
var lectureTimeListG = [LectureTimeObject]()
var lectureCheckTimerG: Timer?
var timeIntervalG = 0.0
var isAbleToStartTimerG = true
var currentVC: UIViewController?
var today = Date()

//チャット関連
var chatRoomsG = [ChatRoom]()
var cachedJoinedTimeG:[String: Date] = [:]
