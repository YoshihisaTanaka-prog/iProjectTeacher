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
    
    private var toolBar:UIToolbar!
    private var tagNum: Int8!
    private var firstDate: Date!
    private var firstTime = Date()
    private var endDate: Date!
    private var endTime = Date()
    private var selectedDate: Date!
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var textTextView: UITextView!
    @IBOutlet private var firstDateTextField: UITextField!
    @IBOutlet private var firstTimeTextField: UITextField!
    @IBOutlet private var endDateTextField: UITextField!
    @IBOutlet private var endTimeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstDateTextField.delegate = self
        firstDateTextField.tag = 1
        firstTimeTextField.delegate = self
        firstTimeTextField.tag = 2
        endDateTextField.delegate = self
        endDateTextField.tag = 3
        endTimeTextField.delegate = self
        endTimeTextField.tag = 4
        
        firstDateTextField.text = sentDate.ymdJp
        firstTimeTextField.text = firstTime.hmJp
        endDateTextField.text = sentDate.ymdJp
        endTimeTextField.text = endTime.hmJp
        
        firstDate = sentDate
        endDate = sentDate
        
        setupToolbar()

        setBackGround(true, true)
        // Do any additional setup after loading the view.
    }
}

//NCMBへの保存部分
extension NormalEventViewController{
    @IBAction private func save(){
        if(firstDate == endDate && firstTime == endTime){
            showOkAlert(title: "エラー", message: "イベントの時間が0分です！")
            return
        }
        
        let c = Calendar.current
        let fTime = c.component(.hour, from: firstTime)
        var eTime = c.component(.hour, from: endTime)
        if c.component(.minute, from: endTime) != 0{
            eTime += 1
        }
        var objects = [NCMBObject]()
        var day = firstDate!
        var isbooking = false
        while day <= endDate {
            var firstNum = businessHoursG[getWeekIdx(firstDate)].first
            var endNum = businessHoursG[getWeekIdx(firstDate)].last
            if day == firstDate{
                firstNum = max(businessHoursG[getWeekIdx(firstDate)].first, fTime)
            }
            if day == endDate{
                endNum = min(businessHoursG[getWeekIdx(firstDate)].last, eTime)
            }
            
            if(firstNum < endNum){
                for i in firstNum..<endNum{
                    if(myScheduleG.searchSchedule(date: day, time: i * 100) == nil){
//                        予定が入っていない場合は新規作成
                        let object = NCMBObject(className: "Schedule")!
                        object.setObject(currentUserG.userId, forKey: "teacherId")
                        object.setObject(nil, forKey: "studentId")
                        object.setObject(eventType, forKey: "eventType")
                        object.setObject(i * 100, forKey: "time")
                        object.setObject(day.y * 100 + day.m, forKey: "ym")
                        object.setObject(day.d, forKey: "date")
                        object.setObject(nil, forKey: "lectureId")
                        object.setObject(titleTextField.text!, forKey: "title")
                        objects.append(object)
                    } else if ( eventTypeRankG[myScheduleG.searchSchedule(date: day, time: i * 100)!.eventType]! <= eventTypeRankG[eventType]! ){
//                        予定が入っていても予定の重要度が低い場合は上書き保存
                        let object = myScheduleG.searchSchedule(date: day, time: i * 100)!.ncmb!
                        object.setObject(currentUserG.userId, forKey: "teacherId")
                        object.setObject(nil, forKey: "studentId")
                        object.setObject(eventType, forKey: "eventType")
                        object.setObject(i * 100, forKey: "time")
                        object.setObject(day.y * 100 + day.m, forKey: "ym")
                        object.setObject(day.d, forKey: "date")
                        object.setObject(nil, forKey: "lectureId")
                        object.setObject(titleTextField.text!, forKey: "title")
                        objects.append(object)
                        isbooking = true
                    } else {
                        isbooking = true
                    }
                }
            }
            day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
        }
        
        if objects.count == 0 {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        myScheduleG.addSchedule(objects: objects)
        if mixedScheduleG.count != 0 {
            mixedScheduleG.addSchedule(objects: objects)
        }
        
        for i in 0..<objects.count{
            let object = objects[i]
            object.saveInBackground({ error in
                if( error == nil && i == objects.count - 1 ){
                    if isbooking{
                        self.showOkAlert(title: "注意", message: "他の予定と重複していました。") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else{
                        self.navigationController?.popViewController(animated: true)
                    }
                } else if(error != nil){
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
        }
    }
}

//曜日判定を行う部分
extension NormalEventViewController{
    // 祝日判定を行い結果を返すメソッド
    func judgeHoliday(_ date : Date) -> Bool {
        let holiday = CalculateCalendarLogic()
        return holiday.judgeJapaneseHoliday(year: date.y, month: date.m, day: date.d)
    }
    //曜日判定
    func getWeekIdx(_ date: Date) -> Int{
        if judgeHoliday(date){
            return 6
        }
        let tmpCalendar = Calendar(identifier: .gregorian)
        return (tmpCalendar.component(.weekday, from: date) + 5) % 7
    }
}

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
        if(textField.tag % 2 == 0){
            datePickerView.datePickerMode = UIDatePicker.Mode.time
        } else {
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            if textField.tag == 1{
                datePickerView.setDate(self.firstDate, animated: false)
            } else {
                datePickerView.setDate(self.endDate, animated: false)
            }
        }
        datePickerView.preferredDatePickerStyle = .wheels
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    //datepickerが選択されたらselectedDateを更新
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        selectedDate = sender.date
    }
}
