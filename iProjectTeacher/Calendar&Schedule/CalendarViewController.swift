//
//  CalendarViewController.swift
//  iProjectTeacher
//
//  Created by Ryusei Hiraoka on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    var student: User?
    
    private var selectedDate: Date!
    private var selectedEventType = ""
    private var currentMonth: Int!
    private var schedules: [[TimeFrameUnit]] = []
    private var scheduleObject: Schedules!
    private var userIds:[String] = []
    
    @IBOutlet private var tableView: UITableView!  //スケジュール内容
    @IBOutlet private var labelTitle: UILabel!  //「主なスケジュール」の表示
    //カレンダー部分
    @IBOutlet private var datelabel: UILabel!  //日付の表示
    @IBOutlet private var calenderView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        setBackGround(true, true)
        calenderView.setToJapanise()
        let tmpCalendar = Calendar(identifier: .gregorian)
        let now = Date()
        selectedDate = tmpCalendar.date(from: DateComponents(year: now.y, month: now.m, day: now.d))!
        currentMonth = selectedDate.m
        
        userIds.append(currentUserG.userId)
        if student != nil{
            self.navigationItem.title = student!.userName + "さんとのスケジュール"
            userIds.append(student!.userId)
        }
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if student == nil{
            scheduleObject = myScheduleG
        } else {
            scheduleObject = mixedScheduleG
        }
        scheduleObject.delegate = self
        scheduleObject.loadSchedule(date: selectedDate, userIds: userIds, self)
        datelabel.text = selectedDate.ymdJp
        loadEvent(selectedDate)
    }
}

//イベントの追加
extension CalendarViewController{
    @IBAction func tappedPlus(){
        let alertController = UIAlertController(title: "予定の種類を選択", message: "", preferredStyle: .actionSheet)
        if( student != nil){
            let telectureSchedule = UIAlertAction(title: "Telecture", style: .default) { (action) in
                self.performSegue(withIdentifier: "Telecture", sender: nil)
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(telectureSchedule)
        }
        let collageSchedule = UIAlertAction(title: "大学の予定", style: .default) { (action) in
            self.selectedEventType = "School"
            self.performSegue(withIdentifier: "Normal", sender: nil)
            alertController.dismiss(animated: true, completion: nil)
        }
        let privateSchedule = UIAlertAction(title: "私用", style: .default) { (action) in
            self.selectedEventType = "private"
            self.performSegue(withIdentifier: "Normal", sender: nil)
            alertController.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(collageSchedule)
        alertController.addAction(privateSchedule)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//イベントの取得と表示
extension CalendarViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(schedules.count,1)
    }
    
//    テーブルビューセルの表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.backgroundColor = .clear
        if(schedules.count == 0){
            cell.textLabel?.text = "予定はありません"
            cell.textLabel?.textColor = .gray
        }
        else{
            let time = businessHoursG[(getWeekIdx(selectedDate) + 5) % 7].first + indexPath.row
            cell.textLabel?.text = time.s02 + ":00-" + (time + 1).s02 + ":00  " + schedules[indexPath.row][0].title
            cell.textLabel?.textColor = .black
        }
        return cell
    }
    
//    テーブルビューセル選択時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.backgroundColor = .none
//        if(schedules.count != 0){
//            let alertController = UIAlertController(title: "確認", message: "このイベントを削除しますか？", preferredStyle: .actionSheet)
//            let alertOkAction = UIAlertAction(title: "削除", style: .destructive) { (action) in
//                self.schedules[indexPath.row][0].ncmb?.deleteInBackground({ error in
//                    if error != nil{
//                        self.showOkAlert(title: "Error", message: error!.localizedDescription)
//                    }
//                })
//                alertController.dismiss(animated: true, completion: nil)
//                self.loadEvent(self.selectedDate)
//            }
//            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
//                alertController.dismiss(animated: true, completion: nil)
//            }
//            alertController.addAction(alertOkAction)
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
        self.tableView.reloadData()
    }
    
    func loadEvent(_ date: Date) {
        //予定がある場合、スケジュールをDBから取得・表示する。
        schedules = scheduleObject.showTimeFrame(date: date)
        for s in schedules{
            print("0 >>", s[0].time, s[0].title, s[0].isMyEvent, "1 >>", s[1].time, s[1].title, s[1].isMyEvent)
        }
        tableView.reloadData()
    }
}
    
//カレンダー関係
extension CalendarViewController: ScheduleDelegate{
    func allSchedulesDidLoaded() {
        calenderView.reloadData()
        if student == nil{
            myScheduleG = scheduleObject
        } else{
            mixedScheduleG = scheduleObject
        }
        loadEvent(selectedDate)
    }
    
    func schedulesDidLoaded() {}
    
    // 祝日判定を行い結果を返すメソッド
    func judgeHoliday(_ date : Date) -> Bool {
        let holiday = CalculateCalendarLogic()
        return holiday.judgeJapaneseHoliday(year: date.y, month: date.m, day: date.d)
    }
    
    //曜日判定
    func getWeekIdx(_ date: Date) -> Int{
        if judgeHoliday(date){
            return 1
        }
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let inputMonth = tmpCalendar.component(.month, from: date)
        if(inputMonth == currentMonth){
            
            //土日の判定
            let weekday = self.getWeekIdx(date)
            if weekday == 1 {
                return UIColor(iRed: 255, iGreen: 0, iBlue: 0)
            }
            else if weekday == 7 {
                return UIColor(iRed: 0, iGreen: 0, iBlue: 255)
            }
            else{
                return dColor.font
            }
        }
        else{
            
            //土日の判定
            let weekday = self.getWeekIdx(date)
            if weekday == 1 {
                return UIColor(iRed: 255, iGreen: 127, iBlue: 127)
            }
            else if weekday == 7 {
                return UIColor(iRed: 127, iGreen: 192, iBlue: 255)
            }
            else{
                return nil
            }
        }
    }
    
    //カレンダーで日付を選択された時の処理(スケジュール表示処理)
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let inputMonth = date.m
        selectedDate = date
        datelabel.text = date.ymdJp
        loadEvent(selectedDate)
//        他の月を選んだ時に移動する
        if(currentMonth != inputMonth){
            calenderView.setCurrentPage(date, animated: true)
            scheduleObject.loadSchedule(date: selectedDate, userIds: userIds, self)
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if scheduleObject.isExistsSchedule(date: date) {
            return 1
        } else {
            return 0
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let date = tmpCalendar.date(from: DateComponents(year: calendar.currentPage.y, month: calendar.currentPage.m, day: 1))!
        scheduleObject.loadSchedule(date: date, userIds: userIds, self)
        currentMonth = tmpCalendar.component(.month, from: calendar.currentPage)
        calenderView.reloadData()
        loadEvent(selectedDate)
    }
    
}

//値渡し
extension CalendarViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Telecture":
            let view2 = segue.destination as! TelectureEventViewController
            view2.sentDate = selectedDate
            view2.student = student!
        case "Normal":
            let view2 = segue.destination as! NormalEventViewController
            view2.sentDate = selectedDate
            view2.eventType = selectedEventType
        default:
            break
        }
    }
    
}


