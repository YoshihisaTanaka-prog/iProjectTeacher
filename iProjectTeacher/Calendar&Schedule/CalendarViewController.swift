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
    
    private var selectedDate = Date()
    private var currentMonth: Int!
    private var schedules: [[Schedule]] = []
    private var scheduleObject: Schedules!
    private var users:[User] = []
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
        currentMonth = tmpCalendar.component(.month, from: Date())
        
        users.append(currentUserG)
        userIds.append(currentUserG.userId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datelabel.text = selectedDate.ymdJp
//        scheduleObject = myScheduleG
        loadEvent(selectedDate)
        calenderView.reloadData()
    }
}

extension CalendarViewController{
    @IBAction func tappedPlus(){
        let alertController = UIAlertController(title: "予定の種類を選択", message: "", preferredStyle: .actionSheet)
        let telectureSchedule = UIAlertAction(title: "Telecture", style: .default) { (action) in
            self.performSegue(withIdentifier: "Telecture", sender: nil)
            alertController.dismiss(animated: true, completion: nil)
        }
        let collageSchedule = UIAlertAction(title: "大学の予定", style: .default) { (action) in
            self.performSegue(withIdentifier: "Collage", sender: nil)
            alertController.dismiss(animated: true, completion: nil)
        }
        let privateSchedule = UIAlertAction(title: "私用", style: .default) { (action) in
            self.performSegue(withIdentifier: "Private", sender: nil)
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(telectureSchedule)
        alertController.addAction(collageSchedule)
        alertController.addAction(privateSchedule)
        self.present(alertController, animated: true, completion: nil)
    }
}

//イベントの取得と表示
extension CalendarViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(schedules.count,1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.backgroundColor = .clear
        if(schedules.count == 0){
            cell.textLabel?.text = "予定はありません"
            cell.textLabel?.textColor = .gray
        }
        else{
            let time = businessHoursG[(getWeekIdx(selectedDate) + 5) % 7].first + indexPath.row
            cell.textLabel?.text = time.s02 + ":00-" + (time + 1).s02 + ":00  " + schedules[indexPath.row][0].eventName
            cell.textLabel?.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = .none
        if(schedules.count != 0){
            let alertController = UIAlertController(title: "確認", message: "このイベントを削除しますか？", preferredStyle: .actionSheet)
            let alertOkAction = UIAlertAction(title: "削除", style: .destructive) { (action) in
                self.schedules[indexPath.row][0].ncmb?.deleteInBackground({ error in
                    if error != nil{
                        self.showOkAlert(title: "Error", message: error!.localizedDescription)
                    }
                })
                alertController.dismiss(animated: true, completion: nil)
                self.loadEvent(self.selectedDate)
            }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertOkAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        self.tableView.reloadData()
    }
    
    func loadEvent(_ date: Date) {
        //予定がある場合、スケジュールをDBから取得・表示する。
        schedules = scheduleObject.scheduleLists(date: date, users: users)
        tableView.reloadData()
    }
}
    
//ここからカレンダー関係
extension CalendarViewController{
    
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
        let tmpCalendar = Calendar(identifier: .gregorian)
        let inputMonth = tmpCalendar.component(.month, from: date)
        if(currentMonth != inputMonth){
            calenderView.setCurrentPage(date, animated: true)
        }
        selectedDate = date
        datelabel.text = date.ymdJp
        loadEvent(selectedDate)
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
        currentMonth = tmpCalendar.component(.month, from: calendar.currentPage)
        calenderView.reloadData()
    }
    
}

//ここから値渡し
extension CalendarViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Telecture":
            let view2 = segue.destination as! EventViewController
            view2.sentDate = selectedDate
        case "Collage":
            let view2 = segue.destination as! NormalEventViewController
            view2.sentDate = selectedDate
            view2.eventType = "school"
        case "Private":
            let view2 = segue.destination as! NormalEventViewController
            view2.sentDate = selectedDate
            view2.eventType = "private"
        default:
            break
        }
    }
    
}


