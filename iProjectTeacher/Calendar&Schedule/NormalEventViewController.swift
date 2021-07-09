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
