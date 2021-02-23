//
//  EventViewController.swift
//  iProjectTeacher
//
//  Created by Ryusei Hiraoka on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//
import UIKit
import RealmSwift
import NCMB

class EventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //スケジュール内容入力テキスト
    @IBOutlet var eventText: UITextView!
    //日付フォーム(UIDatePickerを使用)
    @IBOutlet var y: UIDatePicker!
    //日付表示
    @IBOutlet var y_text: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var studentLabel: UILabel!
    
    var subjectName = "教科を選択"
    var subjectNameList = ["教科を選択","国語","数学","理科","社会","英語"]
    var date: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventText.text = ""
        eventText.layer.borderWidth = 1.f
        eventText.layer.borderColor = UIColor.black.cgColor
        eventText.layer.cornerRadius = 10.f
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        y_text.text = formatter.string(from: y.date)
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectNameList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectNameList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectName = subjectNameList[row]
    }
    
    
    //画面遷移(カレンダーページ)
    @IBAction func onbackClick(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //日付フォーム
    @IBAction func picker(_ sender:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        y_text.text = formatter.string(from: sender.date)
    }

    //DB書き込み処理
    @IBAction func saveEvent(_ : UIButton){
        if(subjectName == "教科を選択"){
            showOkAlert(title: "注意", message: "教科を選択してください。")
            pickerView.backgroundColor = .yellow
        }
        else if(eventText.text.count == 0){
            showOkAlert(title: "注意", message: "イベントを入力してください。")
            eventText.backgroundColor = .yellow
        }
        else{
            print("データ書き込み開始")
            
            let realm = try! Realm()
            
            try! realm.write {
                //日付表示の内容とスケジュール入力の内容が書き込まれる。
                let Events = [Event(value: ["date": y_text.text, "event": studentLabel.text! + "(" + subjectName + ")" + eventText.text])]
                realm.add(Events)
                print("データ書き込み中")
            }
            
            print("データ書き込み完了")
            
            
            
            let object = NCMBObject(className:"ScheduleTeacher")
            object?.setObject(NCMBUser.current().objectId,forKey:"teacherId")
            object?.setObject(subjectName, forKey:"subject" )
            object?.setObject(y_text.text, forKey: "whenDo")
            object?.setObject(eventText.text, forKey: "whatToDo")
            object?.saveInBackground({ (error) in
                if(error == nil){
                    //前のページに戻る
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
            
        }
    }
    
}
