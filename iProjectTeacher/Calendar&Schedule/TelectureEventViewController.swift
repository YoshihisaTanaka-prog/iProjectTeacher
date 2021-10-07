//
//  TelectureEventViewController.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/08.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class TelectureEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    var student: User!
    var sentDate: Date!
    var calenderVC: CalendarViewController!
    var sentLecture: Lecture?
    
    private var limitDate: Date!
    private var toolBar:UIToolbar!
    private var selectedDate: Date!
    private var alert: UIAlertController!
    
//    教科用の　ク ラ ス 内 変数・定数
    private var selectedSubject = ""
    private var selectedSubjectId = 0
    private var selectedSubjectList = [["------",""]]
    private let mainSubjectList = [["教科を選択",""],["国語",""],["数学",""],["理科",""],["社会",""],["英語",""]]
    private let subSubjectList = [
        [["------",""]],
        [["科目を選択",""],["現代文","modernWriting"],["古文","ancientWiting"],["漢文","chineseWriting"]],
        [["科目を選択",""],["数学Ⅰ・A","math1a"],["数学Ⅱ・B","math2b"],["数学Ⅲ・C","math3c"]],
        [["科目を選択",""],["物理","physics"],["化学","chemistry"],["生物","biology"],["地学","earthScience"]],
        [["科目を選択",""],["地理","geography"],["日本史","japaneseHistory"],["世界史","worldHistory"],
         ["現代社会","modernSociety"],["倫理","ethics"],["政治・経済","politicalScienceAndEconomics"]],
        [["科目を選択",""],["高校英語","hsEnglish"]]
    ]
    private var reports = [Report]()
    private var selectedTimeIndex = 0
    private var timeTitleList = [String]()
    private var timeNumList = [Int]()
    
    private var isTappedLoop = false
    
    @IBOutlet private var subjectPickerView: UIPickerView!
    @IBOutlet private var dateTextField: UITextField!
    @IBOutlet private var timePickerView: UIPickerView!
    @IBOutlet private var detailTextView: UITextView!
    @IBOutlet private var loopView: UIView!
    @IBOutlet private var loopSwitch: UISwitch!
    @IBOutlet private var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tmp = Calendar(identifier: .gregorian)
        let now = Date()
        limitDate = tmp.date(from: DateComponents(year: now.y, month: now.m, day: now.d))!
        limitDate = tmp.date(byAdding: .day, value: 3, to: limitDate)!

        subjectPickerView.dataSource = self
        subjectPickerView.delegate = self
        if sentLecture == nil{
            if sentDate < limitDate {
                sentDate = limitDate
                showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか追加できません。")
            }
            dateTextField.text = sentDate.ymdJp
            timePickerView.dataSource = self
            timePickerView.delegate = self
            timePickerView.tag = 1
        } else{
            if sentLecture!.startTime < limitDate{
                showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか編集できません。")
                saveButton.alpha = 0.5.f
                saveButton.isEnabled = false
            }
            dateTextField.text = sentLecture!.startTime.ymdJp + sentLecture!.startTime.hmJp
            dateTextField.isEnabled = false
            setSubjectPickerView()
            timePickerView.alpha = 0.f
            detailTextView.text = sentLecture!.detail
        }
        detailTextView.delegate = self
        
        self.setBackGround(true, true)
        self.navigationItem.title = student.userName + "さんの授業を追加"
        setupToolbar()
        setTimeList()
        if student.status == 2 {
            loopSwitch.setOn(isTappedLoop, animated: false)
        } else {
            loopView.alpha = 0.f
            loopSwitch.isEnabled = false
        }
    }
}

extension TelectureEventViewController{
//    授業情報の編集時に科目を指定するための関数
    private func setSubjectPickerView(){
        if let subject = sentLecture?.subject{
            selectedSubject = subject
            for i in 0..<subSubjectList.count{
                let subjects = subSubjectList[i]
                for j in 0..<subjects.count{
                    let s = subjects[j][1]
                    if s == subject{
                        selectedSubjectList = subSubjectList[i]
                        subjectPickerView.selectRow(i, inComponent: 0, animated: false)
                        subjectPickerView.selectRow(j, inComponent: 1, animated: false)
                        return
                    }
                }
            }
        }
    }
}

//IBAction関連
extension TelectureEventViewController{
    
    @IBAction func showPastReport(){
        if(selectedSubject == ""){
            self.showOkAlert(title: "注意", message: "教科・科目を選択してください！")
        } else{
            let query = ncmbQuery(className: "Report",userIdFields: ["studentId"])
            query?.whereKey("studentId", equalTo: student.userId)
            query?.whereKey("subject", equalTo: selectedSubjectList[selectedSubjectId][0])
            query?.findObjectsInBackground({ result, error in
                if error == nil{
                    self.reports = []
                    let objects = result as? [NCMBObject] ?? []
                    for o in objects{
                        self.reports.append(Report(o))
                    }
                    self.performSegue(withIdentifier: "Report", sender: nil)
                } else{
                    self.showOkAlert(title: "Loading Report Error", message: error!.localizedDescription)
                }
            })
        }
    }
    
//    関連付けが外れるかも。
    @IBAction func tappedLoopSwitch(sender: UISwitch){
        isTappedLoop = sender.isOn
    }
    
    @IBAction func tappedSave(){
        
        if let lecture = sentLecture{
            alert = UIAlertController(title: "保存", message: "データを保存中です。\nしばらくお待ちください。", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let l = Lecture(id: lecture.objectId, student: lecture.student, startTime: lecture.startTime, subject: selectedSubject, detail: detailTextView.text, lecturesId: lecture.lecturesId, self)
            l.delegate = self
        } else if selectedTimeIndex == 0 {
            showOkAlert(title: "注意", message: "時間を選択してください。")
        } else if selectedSubject == ""{
            showOkAlert(title: "注意", message: "教科・科目を選択してください！")
        } else{
            if isTappedLoop {
//                重複している予定があったらスキップさせる。
                var bookingDateList = [Date]()
                var saveDateList = [Date]()
                
                let tmp = Calendar(identifier: .gregorian)
                let time = tmp.date(from: DateComponents(hour: timeNumList[selectedTimeIndex]))!
                for i in 0..<10 {
                    let d = tmp.date(byAdding: .day, value: 7*i, to: selectedDate)!
                    let date = Date().mixDateAndTime(date: d, time: time)
                    let timeFrames = mixedScheduleG.searchSchedule(date: sentDate, time: timeNumList[selectedTimeIndex])
                    if timeFrames.count == 0 {
                        saveDateList.append(date)
                    } else if !timeFrames[0].isMyEvent && timeFrames[0].eventType == "hope"{
                        saveDateList.append(date)
                    } else{
                        bookingDateList.append(date)
                    }
                }
                
                if saveDateList.count == 0 {
                    showOkAlert(title: "注意", message: "全ての日程で予定が重複しています。")
                } else{
                    bookingDateList = bookingDateList.sorted(by: { a, b in
                        return a < b
                    })
                    saveDateList = saveDateList.sorted(by: { a, b in
                        return a < b
                    })
                    var txt = ""
                    if bookingDateList.count == 0{
                        saveLecture(saveDateList: saveDateList)
                    } else{
                        for i in 0..<bookingDateList.count{
                            let d = bookingDateList[i]
                            txt += d.ymdJp + " " + d.hmJp + "\n"
                        }
                        txt += "は予定が重複しています。\nこれらを除外して予定を保存しますか？"
                        let alertController = UIAlertController(title: "注意", message: txt, preferredStyle: .alert)
                        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            self.saveLecture(saveDateList: saveDateList)
                            alertController.dismiss(animated: true, completion: nil)
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                            alertController.dismiss(animated: true, completion: nil)
                        }
                        alertController.addAction(alertOkAction)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            } else{
                let timeFrames = mixedScheduleG.searchSchedule(date: sentDate, time: timeNumList[selectedTimeIndex])
                if timeFrames.count == 0 {
                    let tmp = Calendar(identifier: .gregorian)
                    let time = tmp.date(from: DateComponents(hour: timeNumList[selectedTimeIndex]))!
                    let date = Date().mixDateAndTime(date: sentDate, time: time)
                    saveLecture(saveDateList: [date])
                } else if !timeFrames[0].isMyEvent && timeFrames[0].eventType == "hope"{
                    let tmp = Calendar(identifier: .gregorian)
                    let time = tmp.date(from: DateComponents(hour: timeNumList[selectedTimeIndex]))!
                    let date = Date().mixDateAndTime(date: sentDate, time: time)
                    saveLecture(saveDateList: [date])
                } else{
                    showOkAlert(title: "注意", message: "予定が重複しています。")
                }
            }
        }
    }
    private func saveLecture(saveDateList: [Date]){
        alert = UIAlertController(title: "保存", message: "データを保存中です。\nしばらくお待ちください。", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let object = NCMBObject(className: "Lectures")
        object?.saveInBackground({ error in
            if error == nil{
                for i in 0..<saveDateList.count{
                    let time = saveDateList[i]
                    let l = Lecture(id: nil, student: self.student, startTime: time, subject: self.selectedSubject, detail: self.detailTextView.text!, lecturesId: object!.objectId, self)
                    if i == saveDateList.count - 1{
                        l.delegate = self
                    }
                }
            } else{
                self.alert.dismiss(animated: true, completion: nil)
                self.showOkAlert(title: "Saving main data error", message: error!.localizedDescription)
            }
        })
    }
}

extension TelectureEventViewController: LectureDelegate{
    
    func savedLecture() {
        self.navigationController?.popViewController(animated: false)
        print("savedLecture()was called")
        alert.dismiss(animated: true, completion: nil)
        mixedScheduleG.delegate = calenderVC
        mixedScheduleG.loadSchedule(date: self.sentDate, userIds: [currentUserG.userId, self.student.userId], calenderVC)
    }
}

//テキストフィールド、テキストビュー関連
extension TelectureEventViewController: UITextFieldDelegate{
    private func setupToolbar() {
        //datepicker上のtoolbarのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "決定", style: .plain, target: self, action: #selector(doneBtn))
        toolBar.items = [toolBarBtn]
        dateTextField.inputAccessoryView = toolBar
        dateTextField.delegate = self
        selectedDate = sentDate
    }
//    決定ボタンを押したときの処理
    @objc func doneBtn(){
        if selectedDate < limitDate {
            selectedDate = limitDate
            showOkAlert(title: "注意", message: limitDate.ymdJp + "以降の予定しか追加できません。")
        }
        sentDate = selectedDate
        dateTextField.text = sentDate.ymdJp
        dateTextField.resignFirstResponder()
        selectedTimeIndex = 0
        setTimeList()
        timePickerView.selectRow(0, inComponent: 0, animated: true)
        timePickerView.reloadAllComponents()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.setDate(self.selectedDate, animated: false)
        datePickerView.preferredDatePickerStyle = .wheels
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // キーボード入力や、カット/ペースによる変更を防ぐ
        return false
    }
    //datepickerが選択されたらselectedDateを更新
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        selectedDate = sender.date
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

//ピッカービュー関連
extension TelectureEventViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            switch component {
            case 0:
                return mainSubjectList.count
            case 1:
                return selectedSubjectList.count
            default:
                return 0
            }
        case 1:
            return timeNumList.count
        default:
            return 0
        }
    }
    
//    ピッカービューに表示する内容を指定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            switch component {
            case 0:
                return mainSubjectList[row][0]
            case 1:
                return selectedSubjectList[row][0]
            default:
                return ""
            }
        case 1:
            return timeTitleList[row]
        default:
            return ""
        }
    }
    
//    ピッカービューが選ばれた時の処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            switch component {
            case 0:
                selectedSubjectList = subSubjectList[row]
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                selectedSubject = mainSubjectList[row][1]
            case 1:
                selectedSubject = selectedSubjectList[row][1]
                selectedSubjectId = row
            default:
                break
            }
        case 1:
            selectedTimeIndex = row
        default:
            break
        }
    }
}

//時間リストの設定
extension TelectureEventViewController{
    private func setTimeList(){
        timeTitleList = ["時間を選択"]
        timeNumList = [0]
        var teacherTimeList = [Int]()
        for s in currentUserG.youbiTimeList[selectedDate.weekId]{
            let list = s.split(separator: ":")
            teacherTimeList.append(Int(list.first!)!)
        }
        var studentTimeList = [Int]()
        for s in student.youbiTimeList[selectedDate.weekId]{
            let list = s.split(separator: ":")
            studentTimeList.append(Int(list.first!)!)
        }
        for i in businessHoursG[sentDate.weekId].first..<businessHoursG[sentDate.weekId].last{
            let timeFrames = mixedScheduleG.searchSchedule(date: sentDate, time: i)
            if teacherTimeList.contains(i) && studentTimeList.contains(i){
                if timeFrames.count == 0 {
                    timeTitleList.append(i.s02 + ":00 - " + (i+1).s02 + ":00")
                    timeNumList.append(i)
                } else if !timeFrames[0].isMyEvent && timeFrames[0].eventType == "hope"{
                    timeTitleList.append("☆" + i.s02 + ":00 - " + (i+1).s02 + ":00☆")
                    timeNumList.append(i)
                }
            }
        }
        if timeNumList.count == 1{
            showOkAlert(title: "注意", message: "選択された日付はコマを追加することができません。")
        }
    }
}

//値渡し
extension TelectureEventViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Report":
            let nextVC = segue.destination as! ReportListViewController
            nextVC.reportList = reports
        default:
            break
        }
    }
}
