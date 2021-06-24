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

//var screenSizeG: Dictionary<String, Size> = [:]
var userImagesCacheG: Dictionary<String, UIImage> = [:]
let dColor = OriginalCollor()
var isLogInG: Bool = false
var currentUserG: User!
var blockUserListG: [User] = []
var followUserListG: [User] = []

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
