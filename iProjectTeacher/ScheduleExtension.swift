//
//  ScheduleExtension.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/06/27.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

extension UIViewController{
    func loadSchedule(_ userIds: [String]){
        if userIds.count == 1{
            myScheduleG.loadSchedule(date: Date(), userIds: userIds, self)
        } else {
            mixedScheduleG.loadSchedule(date: Date(), userIds: userIds, self)
        }
    }
}
