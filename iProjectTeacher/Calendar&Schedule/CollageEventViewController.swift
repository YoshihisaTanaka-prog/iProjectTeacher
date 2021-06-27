//
//  CollageEventViewController.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/06/24.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class CollageEventViewController: UIViewController, UITextFieldDelegate {
    
    var sentDate: Date!
    
    private var toolBar:UIToolbar!
    private var firstDate: Date!
    private var endDate: Date!
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
        
        firstDateTextField.text = sentDate.y.s + "/" + sentDate.m.s + "/" + sentDate.d.s
        endDateTextField.text = sentDate.y.s + "/" + sentDate.m.s + "/" + sentDate.d.s
        
        firstDate = sentDate
        endDate = sentDate
        
        setupToolbar()

        // Do any additional setup after loading the view.
    }
    
    private func setupToolbar() {
        //datepicker上のtoolbarのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(doneBtn))
        toolBar.items = [toolBarBtn]
        firstDateTextField.inputAccessoryView = toolBar
        firstTimeTextField.inputAccessoryView = toolBar
        endDateTextField.inputAccessoryView = toolBar
        endTimeTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneBtn(){
        firstDateTextField.resignFirstResponder()
        firstTimeTextField.resignFirstResponder()
        endDateTextField.resignFirstResponder()
        endTimeTextField.resignFirstResponder()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
        datePickerView.tag = textField.tag
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
        //datepickerが選択されたらtextfieldに表示
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let date = sender.date
        switch sender.tag {
        case 1:
            firstDate = date
            firstDateTextField.text = date.y.s + "/" + date.m.s + "/" + date.d.s
            if endDate < date {
                endDateTextField.text = date.y.s + "/" + date.m.s + "/" + date.d.s
                endDate = date
            }
        case 2:
            break
        case 3:
            endDate = date
            endDateTextField.text = date.y.s + "/" + date.m.s + "/" + date.d.s
            if firstDate > date {
                firstDateTextField.text = date.y.s + "/" + date.m.s + "/" + date.d.s
                firstDate = date
            }
        case 4:
            break
        default:
            break
        }
    }
    
    
    @IBAction private func save(){
        let object = NCMBObject(className: "Schedule")
        object?.setObject(currentUserG.userId, forKey: "teacherId")
        object?.setObject("school", forKey: "eventType")
        
        object?.saveInBackground({ error in
            if(error == nil){
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }

}
