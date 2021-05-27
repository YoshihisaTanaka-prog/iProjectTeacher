//
//  CalenderExtension.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/05/25.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import FSCalendar

extension FSCalendar{
    func setToJapanise(){
        self.appearance.headerDateFormat = "YYYY年M月"
        self.appearance.headerTitleColor = dColor.font
        self.calendarWeekdayView.weekdayLabels[0].text = "日"
        self.calendarWeekdayView.weekdayLabels[0].textColor = .red
        self.calendarWeekdayView.weekdayLabels[1].text = "月"
        self.calendarWeekdayView.weekdayLabels[1].textColor = dColor.font
        self.calendarWeekdayView.weekdayLabels[2].text = "火"
        self.calendarWeekdayView.weekdayLabels[2].textColor = dColor.font
        self.calendarWeekdayView.weekdayLabels[3].text = "水"
        self.calendarWeekdayView.weekdayLabels[3].textColor = dColor.font
        self.calendarWeekdayView.weekdayLabels[4].text = "木"
        self.calendarWeekdayView.weekdayLabels[4].textColor = dColor.font
        self.calendarWeekdayView.weekdayLabels[5].text = "金"
        self.calendarWeekdayView.weekdayLabels[5].textColor = dColor.font
        self.calendarWeekdayView.weekdayLabels[6].text = "土"
        self.calendarWeekdayView.weekdayLabels[6].textColor = .blue
    }
}
