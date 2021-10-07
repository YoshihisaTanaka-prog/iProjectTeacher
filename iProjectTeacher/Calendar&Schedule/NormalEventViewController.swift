//
//  CollageEventViewController.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/06/24.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import CalculateCalendarLogic

class NormalEventViewController: UIViewController, UITextFieldDelegate {
    
    var sentDate: Date!
    var eventType: String!
    var calenderVC: CalendarViewController!
    var sentSchedule: Schedule?
    
    private var size: Size!
    private var toolBar:UIToolbar!
    private var tagNum: Int8!
    private var firstDate: Date!
    private var firstTime: Date!
    private var endDate: Date!
    private var endTime: Date!
    private var limitDate: Date!
    private var selectedDate: Date!
    private var isShownTableView = true
    private var dateTableView = UITableView()
    private var savedDate: [[Date]] = []
    private var alert: UIAlertController?
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var textTextView: UITextView!
    @IBOutlet private var firstDateTextField: UITextField!
    @IBOutlet private var firstTimeTextField: UITextField!
    @IBOutlet private var endDateTextField: UITextField!
    @IBOutlet private var endTimeTextField: UITextField!
    @IBOutlet private var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tmp = Calendar(identifier: .gregorian)
        let d = Date()
        let start = tmp.date(from: DateComponents(hour: d.h, minute: d.min))!
        let end = tmp.date(byAdding: .hour, value: 1, to: start)!
        let now = Date()
        limitDate = tmp.date(from: DateComponents(year: now.y, month: now.m, day: now.d))!
        if sentSchedule == nil{
            print("schedule is nil")
            if sentDate < limitDate {
                sentDate = limitDate
                showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか追加できません。")
            }
            savedDate.append([sentDate, start, end])
            
            firstDate = sentDate
            endDate = sentDate
            firstTime = start
            endTime = end
            
            firstDateTextField.text = sentDate.ymdJp
            firstTimeTextField.text = firstTime.hmJp
            endDateTextField.text = sentDate.ymdJp
            endTimeTextField.text = endTime.hmJp
        } else {
            print("schedule is not nil")
            for detailTimes in sentSchedule!.detailTimeList{
                let d1 = detailTimes[0]
                let d2 = detailTimes[1]
                let start = tmp.date(from: DateComponents(hour: d1.h, minute: d1.min))!
                let end = tmp.date(from: DateComponents(hour: d2.h, minute: d2.min))!
                savedDate.append([d1,start,end])
            }
            titleTextField.text = sentSchedule!.title
            textTextView.text = sentSchedule!.detail
            firstDateTextField.text = sentSchedule!.detailTimeList.first![0].ymdJp
            firstTimeTextField.text = sentSchedule!.detailTimeList.first![0].hmJp
            endDateTextField.text = sentSchedule!.detailTimeList.last![1].ymdJp
            endTimeTextField.text = sentSchedule!.detailTimeList.last![1].hmJp
            if sentSchedule!.detailTimeList.last![1] < limitDate {
                saveButton.isEnabled = false
                saveButton.alpha = 0.5.f
                showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか編集できません。")
            }
        }
        
        switch eventType {
        case "school":
            self.navigationItem.title = "大学の予定を追加"
        case "private":
            self.navigationItem.title = "個人的な予定を追加"
        default:
            break
        }
        
        size = getScreenSize(isExsistsNavigationBar: true, isExsistsTabBar: true)
        
        setupToolbar()
        
        firstDateTextField.delegate = self
        firstDateTextField.tag = 1
        firstTimeTextField.delegate = self
        firstTimeTextField.tag = 2
        endDateTextField.delegate = self
        endDateTextField.tag = 3
        endTimeTextField.delegate = self
        endTimeTextField.tag = 4

        setBackGround(true, true)
        dateTableView.frame = CGRect(x: 0.f, y: 0.f, width: 242.f, height: 242.f)
        dateTableView.center = CGPoint(x: size.width / 2.f, y: 293.f)
        dateTableView.backgroundColor = dColor.base
        setTableView()
        self.view.addSubview(dateTableView)
    }
}

//NCMBへの保存部分
extension NormalEventViewController: ScheduleClassDelegate{
    
    func savedSchedule() {
        alert?.dismiss(animated: true, completion: {
            if let studentId = self.calenderVC.student?.userId{
                mixedScheduleG.delegate = self.calenderVC
                mixedScheduleG.loadSchedule(date: self.sentDate, userIds: [currentUserG.userId, studentId], self.calenderVC)
            } else{
                myScheduleG.delegate = self.calenderVC
            }
            myScheduleG.loadSchedule(date: self.sentDate, userIds: [currentUserG.userId], self.calenderVC)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction private func save(){
        print("save() was called")
        if titleTextField.text!.count == 0{
            showOkAlert(title: "注意", message: "予定のタイトルを入力してください。")
        } else{
            if isShownTableView{
                var detailTimeList = [[Date]]()
                for dlist in savedDate{
                    let d1 = Date().mixDateAndTime(date: dlist[0], time: dlist[1])
                    let d2 = Date().mixDateAndTime(date: dlist[0], time: dlist[2])
                    detailTimeList.append([d1,d2])
                }
                if searchBookingList(dateList: detailTimeList).count == 0 {
                    showWaitingAlert()
                    let s = Schedule(id: sentSchedule?.id, title: titleTextField.text!, detail: textTextView.text!, eventType: eventType, detailTimeList: detailTimeList, isAbleToShow: true, self)
                    s.delegate = self
                }
            } else{
                let first = firstDate.mixDateAndTime(date: firstDate, time: firstTime)
                let end = endDate.mixDateAndTime(date: endDate, time: endTime)
                let detailTimeList = [[first,end]]
                if searchBookingList(dateList: detailTimeList).count == 0 {
                    showWaitingAlert()
                    let s = Schedule(id: sentSchedule?.id, title: titleTextField.text!, detail: textTextView.text!, eventType: eventType, detailTimeList: detailTimeList, isAbleToShow: true, self)
                    s.delegate = self
                }
            }
        }
    }
    
    private func searchBookingList(dateList: [[Date]]) -> [(dates: [Date], timeFrame: TimeFrame)] {
        let c = Calendar(identifier: .gregorian)
        var ret: [(dates: [Date], timeFrame: TimeFrame)] = []
        for dList in dateList{
            var dStart = dList[0]
            var dEnd = c.date(from: DateComponents(year: dStart.y, month: dStart.m, day: dStart.d + 1))!
            if dEnd > dList[1]{
                dEnd = dList[1]
            }
            while(dStart < dList[1]){
                for key in cachedScheduleG.keys {
                    let s = cachedScheduleG[key]!
                    if let id = sentSchedule?.id {
                        if id == key{
                            continue
                        }
                    }
                    if s.userId == currentUserG.userId{
                        for times in s.detailTimeList{
                            let start = times[0]
                            let end = times[1]
                            if (start < dEnd && dStart < end){
                                let t = TimeFrame(firstTime: start, lastTime: end, title: s.title, eventType: s.eventType)
                                t.scheduleIds.append(s.id)
                                ret.append((dates: [start,end], timeFrame: t))
                            }
                        }
                    }
                }
                for l in cachedLectureG.values {
                    if l.teacher.userId == currentUserG.userId{
                        let start = l.startTime
                        let end = c.date(from: DateComponents(year: start.y, month: start.m, day: start.d, hour: start.h + 1))!
                        if (start < dEnd && dStart < end){
                            let t = TimeFrame(firstTime: start, lastTime: end, title: l.subjectName + "/" + l.teacher.userName + "/" + l.student.userName, eventType: "telecture")
                            t.lectureId = l.objectId
                            ret.append((dates: [start,end], timeFrame: t))
                        }
                    }
                }
                dStart = c.date(from: DateComponents(year: dStart.y, month: dStart.m, day: dStart.d + 1))!
                dEnd = c.date(from: DateComponents(year: dStart.y, month: dStart.m, day: dStart.d + 1))!
                if dEnd > dList[1]{
                    dEnd = dList[1]
                }
            }
        }
        return ret
    }
    
    private func showWaitingAlert(){
        alert = UIAlertController(title: "保存中", message: "データを保存しています。", preferredStyle: .alert)
        self.present(alert!, animated: true, completion: nil)
    }
}

//画面の日付けの切り替え部分
extension NormalEventViewController{
    @IBAction private func changeInputDateFormat(){
        if isShownTableView {
            dateTableView.removeFromSuperview()
        } else{
            self.view.addSubview(dateTableView)
            dateTableView.reloadData()
        }
        isShownTableView = !isShownTableView
    }
}

//テーブルビューの設定
extension NormalEventViewController: UITableViewDataSource, UITableViewDelegate, DateTableViewCellDelegate {
    private func setTableView(){
        dateTableView.dataSource = self
        dateTableView.delegate = self
        dateTableView.tableFooterView = UIView()
        let nib1 = UINib(nibName: "PlusTableViewCell", bundle: Bundle.main)
        let nib2 = UINib(nibName: "DateTableViewCell", bundle: Bundle.main)
        dateTableView.register(nib1, forCellReuseIdentifier: "Plus")
        dateTableView.register(nib2, forCellReuseIdentifier: "Date")
    }
    
//    セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == savedDate.count){
            return 44.f
        }
        else{
            return 203.f
        }
    }
    
//    セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedDate.count + 1
    }
    
//    セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == savedDate.count{
            return tableView.dequeueReusableCell(withIdentifier: "Plus") as! PlusTableViewCell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Date") as! DateTableViewCell
            cell.limitDate = self.limitDate
            let ir = indexPath.row
            cell.dateLabel.text = (ir+1).jp + "日目"
            cell.setDate(dates: savedDate[ir])
            cell.tag = ir
            cell.delegate = self
            
            cell.setFontColor()
            
            return cell
        }
    }
    
//    セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == savedDate.count{
            let count = savedDate.count - 1
            var dates = [Date]()
            let tmp = Calendar(identifier: .gregorian)
            let nextDate = tmp.date(byAdding: .day, value: 1, to: savedDate[count][0])!
            dates.append(nextDate)
            dates.append(savedDate[count][1])
            dates.append(savedDate[count][2])
            savedDate.append(dates)
        }
        tableView.reloadData()
    }

//    セル内のテキストフィールドが上書きされた時の処理
    func didSelected(cellId: Int, tag: Int, selectedDate: Date) {
        if tag == 0 && selectedDate < limitDate {
            self.showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか追加できません。")
            dateTableView.reloadData()
        } else {
            savedDate[cellId][tag-1] = selectedDate
            if tag == 1 && savedDate.count > 1{
                var showIndexPath = IndexPath(row: cellId, section: 0)
//                データの入れ換えを1行で済ませるための関数
                func shuffle(i: Int, j: Int){
                    let dates = savedDate[i]
                    savedDate[i] = savedDate[j]
                    savedDate[j] = dates
                }
//                データの和集合を求めて更新するのを1行で済ませるための関数
                func mix(i: Int){
                    var sTime = savedDate[i][1]
                    var eTime = savedDate[i][2]
                    savedDate.remove(at: i)
                    sTime = min(sTime, savedDate[i][1])
                    eTime = max(eTime, savedDate[i][2])
                    savedDate[i][1] = sTime
                    savedDate[i][2] = eTime
                }
//                日付が変更されたらデータを並び替える必要があるかも。
                var isNeedToBack = true
                if cellId != 0 {
//                    必要なら変更されたデータを前方に移動させる。
                    var i = cellId
                    while i>0 {
                        if(savedDate[i][0] < savedDate[i-1][0]){
                            isNeedToBack = false
                            shuffle(i: i, j: i-1)
                            showIndexPath.row = i-1
                        }else if(savedDate[i][0] == savedDate[i-1][0]){
                            mix(i: i-1)
                            showIndexPath.row = i-1
                            break
                        }else {
                            break
                        }
                        i -= 1
                    }
                }
                if cellId != savedDate.count - 1 && isNeedToBack {
//                    必要なら変更されたデータを後方に移動させる
                    var i = cellId
                    while i<savedDate.count - 1 {
                        if(savedDate[i][0] > savedDate[i+1][0]){
                            shuffle(i: i, j: i+1)
                            showIndexPath.row = i+1
                        }else if(savedDate[i][0] == savedDate[i+1][0]){
                            mix(i: i)
                            showIndexPath.row = i
                            break
                        }else {
                            break
                        }
                        i += 1
                    }
                }
                dateTableView.reloadData()
                DispatchQueue.main.async {
                    self.dateTableView.scrollToRow(at: showIndexPath, at: UITableView.ScrollPosition.top, animated: true)
                }
            }
        }
    }
    
}

//日付の選択部分
extension NormalEventViewController{
    private func setupToolbar() {
        //datepicker上のtoolbarのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "決定", style: .plain, target: self, action: #selector(doneBtn))
        toolBar.items = [toolBarBtn]
        firstDateTextField.inputAccessoryView = toolBar
        firstTimeTextField.inputAccessoryView = toolBar
        endDateTextField.inputAccessoryView = toolBar
        endTimeTextField.inputAccessoryView = toolBar
    }
//    決定ボタンを押したときの処理
    @objc func doneBtn(){
        switch tagNum {
        case Int8(1):
            if selectedDate < limitDate {
                selectedDate = limitDate
                showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか追加できません。")
            }
            firstDate = selectedDate
            firstDateTextField.text = firstDate.ymdJp
            if endDate < firstDate{
                endDate = selectedDate
                endDateTextField.text = endDate.ymdJp
            }
            firstDateTextField.resignFirstResponder()
        case Int8(2):
            firstTime = selectedDate
            firstTimeTextField.text = selectedDate.hmJp
            if endDate == firstDate && endTime < firstTime{
                endTime = selectedDate
                endTimeTextField.text = selectedDate.hmJp
            }
            firstTimeTextField.resignFirstResponder()
        case Int8(3):
            if selectedDate < limitDate {
                selectedDate = limitDate
                showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか追加できません。")
            }
            endDate = selectedDate
            endDateTextField.text = endDate.ymdJp
            if endDate < firstDate{
                firstDate = selectedDate
                firstDateTextField.text = firstDate.ymdJp
            }
            endDateTextField.resignFirstResponder()
        case Int8(4):
            endTime = selectedDate
            endTimeTextField.text = selectedDate.hmJp
            if endDate == firstDate && endTime < firstTime{
                firstTime = selectedDate
                firstTimeTextField.text = selectedDate.hmJp
            }
            endTimeTextField.resignFirstResponder()
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tagNum = Int8(textField.tag)
        let datePickerView:UIDatePicker = UIDatePicker()
//        スイッチ文にしてselectedDateの初期値を指定する。
        switch textField.tag {
        case 1:
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            datePickerView.setDate(self.firstDate, animated: false)
            selectedDate = self.firstDate
        case 2:
            datePickerView.datePickerMode = UIDatePicker.Mode.time
            datePickerView.setDate(self.firstTime, animated: false)
            selectedDate = self.firstTime
        case 3:
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            datePickerView.setDate(self.endDate, animated: false)
            selectedDate = self.endDate
        case 4:
            datePickerView.datePickerMode = UIDatePicker.Mode.time
            datePickerView.setDate(self.endTime, animated: false)
            selectedDate = self.endTime
        default:
            return
        }
        datePickerView.preferredDatePickerStyle = .wheels
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // キーボード入力や、カット/ペースによる変更を防ぐ
        return textField.tag == 0
    }
    //datepickerが選択されたらselectedDateを更新
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        selectedDate = sender.date
    }
    
}
