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
    private var toolBar:UIToolbar!
    private var selectedDate: Date!
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
    
    @IBOutlet private var subjectPickerView: UIPickerView!
    @IBOutlet private var dateTextField: UITextField!
    @IBOutlet private var timePickerView: UIPickerView!
    @IBOutlet private var detailTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        subjectPickerView.dataSource = self
        subjectPickerView.delegate = self
        timePickerView.dataSource = self
        timePickerView.delegate = self
        timePickerView.tag = 1
        detailTextView.delegate = self
        
        self.setBackGround(true, true)
        self.navigationItem.title = student.userName + "さんの授業を追加"
        setupToolbar()
        setTimeList()
        
    }
}

//IBAction関連
extension TelectureEventViewController{
    @IBAction func showPastReport(){
        if(selectedSubject == ""){
            self.showOkAlert(title: "注意", message: "教科・科目を選択してください！")
        } else{
            let query = NCMBQuery(className: "Report")
            query?.whereKey("studentId", equalTo: student.userId)
            query?.whereKey("subject", equalTo: selectedSubjectList[selectedSubjectId][0])
            query?.findObjectsInBackground({ result, error in
                if error == nil{
                    self.reports = []
                    let objects = result as? [NCMBObject] ?? []
                    for o in objects{
                        self.reports.append(Report(o))
                    }
//                    ここでページ遷移のコード
                } else{
                    self.showOkAlert(title: "Loading Report Error", message: error!.localizedDescription)
                }
            })
        }
    }
    @IBAction func tappedSave(){
        
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
        dateTextField.text = sentDate.ymdJp
    }
//    決定ボタンを押したときの処理
    @objc func doneBtn(){
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
        timeTitleList = []
        timeNumList = []
        timeTitleList.append("時間を選択")
        timeNumList.append(0)
        for i in businessHoursG[sentDate.weekId].first..<businessHoursG[sentDate.weekId].last{
            if !mixedScheduleG.isExistsSchedule(date: sentDate, time: i){
                timeTitleList.append(i.s02 + ":00 - " + (i+1).s02 + ":00")
                timeNumList.append(i)
            }
        }
    }
}

//値渡し
extension TelectureEventViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}