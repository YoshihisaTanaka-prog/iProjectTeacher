//
//  ReviewDetailViewController.swift
//  iProjectTeacher
//
//  Created by Kaori Nakamura on 5/13/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class ReportDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {

    @IBOutlet private var tangenTextField: UITextField!
    @IBOutlet private var pickerView1: UIPickerView!
    @IBOutlet private var homeworkTextView: UITextView!
    @IBOutlet private var nextplanTextView: UITextView!
    @IBOutlet private var pearentMessageTextView: UITextView!
    @IBOutlet private var otherTeachersMessageTextView: UITextView!

    private var selected: String?
    private let hyouka = ["生徒の授業態度を選択してください","大変良い","まあまあ良い","普通","やや改善が必要","改善が必要"]
    private var report: Report!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround(true, false)
        
//        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
//        userImageView.layer.masksToBounds = true
        
        tangenTextField.delegate = self
        pickerView1.delegate = self
        pickerView1.dataSource = self
        homeworkTextView.delegate = self
        nextplanTextView.delegate = self
        pearentMessageTextView.delegate = self
        otherTeachersMessageTextView.delegate = self

        tangenTextField.text = ""
        homeworkTextView.text = ""
        nextplanTextView.text = ""
        pickerView1.selectRow(0, inComponent: 0, animated: true)
        pearentMessageTextView.text = ""
        otherTeachersMessageTextView.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hyouka.count
        
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hyouka[row]
        
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            selected = hyouka[row]
        } else {
            selected = nil
        }
    }

    
    @IBAction func closeEditViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveUserInfo(){
//        if(selected == nil){
//            showOkAlert(title: "注意", message: "単元を選択してください。")
//        } else {
            createReport()
            let object = report.ncmb
            object.setObject(report.studentId, forKey: "studentId")
            object.setObject(report.teacherId, forKey: "teacherId")
            object.setObject(report.subject, forKey: "subject")
            object.setObject(report.unit, forKey: "unit")
            object.setObject(report.attitude, forKey: "attitude")
            object.setObject(report.homework, forKey: "homework")
            object.setObject(report.nextUnit, forKey: "nextUnit")
            object.setObject(report.messageToParents, forKey: "messageToParents")
            object.setObject(report.messageToTeacher, forKey: "messageToTeacher")
            object.setObject(report.fileNames, forKey: "fileNames")
            object.saveInBackground{ (error) in
                if error != nil {
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    self.showOkAlert(title: "報告書の保存", message: "保護者様に送信いたします。")
                    self.sendReportEmailToParent(object.objectId)
                }
            }
//        }
    }
    
    @IBAction func createReport(){
//        if(selected != nil){
            report = Report(studentId: "eKwToooiFnyI8BHC", teacherId: currentUserG.userId, subject: transformSubject("math1a"), unit: tangenTextField.text ?? "", attitude: selected ?? "", homework: homeworkTextView.text ?? "", nextUnit: nextplanTextView.text, messageToParents: pearentMessageTextView.text ?? "", messageToTeacher: otherTeachersMessageTextView.text ?? "")
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 値を渡すコード
        // 次の画面を取得
        let View2 = segue.destination as! DocumentsViewController
        // 次の画面の変数にこの画面の変数を入れている
        View2.report = report
    }
    
    func getSelectionNum(selesction: String?) -> Int {
        if(selesction == nil){
            return 0
        }
        let i = hyouka.firstIndex(of: selesction!)
        if i == nil {
            return 0
        }
        return i!
    }
    

}
