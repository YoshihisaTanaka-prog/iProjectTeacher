//
//  DateTableViewCell.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/07/15.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

protocol DateTableViewCellDelegate {
    func didSelected(cellId: Int, tag: Int, selectedDate: Date)
}

class DateTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: DateTableViewCellDelegate?
    var limitDate: Date!
    private var date: Date!
    private var selectedDate: Date!
    private var startTime: Date!
    private var endTime: Date!
    private var tagNum: Int!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var endTimeTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // SetUp ToolBar
        
        self.backgroundColor = dColor.base
        self.layer.borderWidth = 1.f
        self.layer.borderColor = dColor.concept.cgColor
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "決定", style: .plain, target: self, action: #selector(doneBtn))
        toolBar.items = [toolBarBtn]
        dateTextField.inputAccessoryView = toolBar
        dateTextField.tag = 1
        dateTextField.delegate = self
        startTimeTextField.inputAccessoryView = toolBar
        startTimeTextField.tag = 2
        startTimeTextField.delegate = self
        endTimeTextField.inputAccessoryView = toolBar
        endTimeTextField.tag = 3
        endTimeTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDate(dates: [Date]){
        let c = Calendar(identifier: .gregorian)
        var d = dates[0]
        date = c.date(from: DateComponents(year: d.y, month: d.m, day: d.d))!
        d = dates[1]
        startTime = c.date(from: DateComponents(hour: d.h, minute: d.min))!
        d = dates[2]
        endTime = c.date(from: DateComponents(hour: d.h, minute: d.min))!
        dateTextField.text = date.ymdJp + " の"
        startTimeTextField.text = startTime.hmJp + " から"
        endTimeTextField.text = endTime.hmJp + " まで"
    }
    
    @objc func doneBtn(){
        switch tagNum {
        case 1:
            dateTextField.text = selectedDate.ymdJp + " の"
            let c = Calendar(identifier: .gregorian)
            date = c.date(from: DateComponents(year: selectedDate.y, month: selectedDate.m, day: selectedDate.d))!
            dateTextField.resignFirstResponder()
        case 2:
            startTimeTextField.text = selectedDate.hmJp + " から"
            let c = Calendar(identifier: .gregorian)
            startTime = c.date(from: DateComponents(hour: selectedDate.h, minute: selectedDate.min))!
            startTimeTextField.resignFirstResponder()
            if (endTime < startTime){
                endTime = startTime
                endTimeTextField.text = selectedDate.hmJp + " まで"
            }
        case 3:
            endTimeTextField.text = selectedDate.hmJp + " まで"
            let c = Calendar(identifier: .gregorian)
            endTime = c.date(from: DateComponents(hour: selectedDate.h, minute: selectedDate.min))!
            endTimeTextField.resignFirstResponder()
            if (endTime < startTime){
                startTime = endTime
                startTimeTextField.text = selectedDate.hmJp + " から"
            }
        default:
            break
        }
        self.delegate?.didSelected(cellId: self.tag, tag: tagNum, selectedDate: selectedDate)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tagNum = textField.tag
        let datePickerView:UIDatePicker = UIDatePicker()
        switch textField.tag {
        case 1:
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            datePickerView.setDate(date, animated: false)
            selectedDate = date
        case 2:
            datePickerView.datePickerMode = UIDatePicker.Mode.time
            datePickerView.setDate(startTime, animated: false)
            selectedDate = startTime
        case 3:
            datePickerView.datePickerMode = UIDatePicker.Mode.time
            datePickerView.setDate(endTime, animated: false)
            selectedDate = endTime
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
