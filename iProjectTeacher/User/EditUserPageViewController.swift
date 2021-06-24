//
//  EditUserPageViewController.swift
//  iProjectTeacher
//
//  Created by Kaori Nakamura on 2/24/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class EditUserPageViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var userIdFuriganaTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    @IBOutlet var gradeTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var selectionTextField: UITextField!
    @IBOutlet var introductionTextView: UITextView!
    
    let kamokuAlertController = UIAlertController(title: "教科を選んでください。", message: "", preferredStyle: .actionSheet)
    let youbiAlertController = UIAlertController(title: "曜日を選んでください。", message: "", preferredStyle: .actionSheet)
    var imageName: String?
    var selected: String?
    let bunri = ["文理選択","文系","理系","その他"]
    var kamokuCheckBox: CheckBox!

    var kamokuCheckBoxList: [CheckBox] = []
    var youbiCheckBoxList: [CheckBox] = []
    var youbiList_: [[CheckBoxInput]] = []
    
    let kamokuList: [[CheckBoxInput]] = [
        [
            CheckBoxInput("現代文", key: "modernWriting"),
            CheckBoxInput("古文", key: "ancientWiting"),
            CheckBoxInput("漢文", key: "chineseWriting")
        ],[
            CheckBoxInput("数学Ⅰ・A", key: "math1a"),
            CheckBoxInput("数学Ⅱ・B", key: "math2b"),
            CheckBoxInput("数学Ⅲ・C", key: "math3c")
        ],[
            CheckBoxInput("物理", key: "physics"),
            CheckBoxInput("化学", key: "chemistry"),
            CheckBoxInput("生物", key: "biology"),
            CheckBoxInput("地学", key: "earthScience")
        ],[
            CheckBoxInput("地理", key: "geography"),
            CheckBoxInput("日本史", key: "japaneseHistory"),
            CheckBoxInput("世界史", key: "worldHistory"),
            CheckBoxInput("現代社会", key: "modernSociety"),
            CheckBoxInput("倫理", key: "ethics"),
            CheckBoxInput("政治経済", key: "politicalScienceAndEconomics")
        ],[
            CheckBoxInput("高校英語", key: "hsEnglish")
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGround(true, true)
        
        for i in 0..<kamokuList.count{
            let kamokuCheckBox = CheckBox(kamokuList[i])
            kamokuCheckBox.setSelectedKey(currentUserG.teacherParameter!.kamokuList[i])
            kamokuCheckBoxList.append(kamokuCheckBox)
        }
        
        for i in 0..<7{
            youbiList_.append([])
            for j in businessHoursG[i].first..<businessHoursG[i].last{
                youbiList_[i].append(CheckBoxInput(j.s02+":00-"+(j+1).s02+":00", key: j.s02+":00"))
            }
        }
        
        for i in 0..<youbiList_.count{
            let youbiCheckBox = CheckBox(youbiList_[i])
            youbiCheckBox.setSelectedKey(currentUserG.youbiTimeList[i])
            youbiCheckBoxList.append(youbiCheckBox)
        }
 
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        userIdTextField.delegate = self
        userIdFuriganaTextField.delegate = self
        schoolTextField.delegate = self
        gradeTextField.delegate = self
        emailTextField.delegate = self
        selectionTextField.delegate = self
        //pickerView1.delegate = self
        //pickerView1.dataSource = self
        //choiceTextField.delegate = self
        introductionTextView.delegate = self
        
        userIdTextField.text = currentUserG.userName
        emailTextField.text = currentUserG.mailAddress
        userIdFuriganaTextField.text = currentUserG.furigana
        schoolTextField.text = currentUserG.teacherParameter?.collage
        //gradeTextField.text = user_.teacherParameter?.grade
        gradeTextField.text = currentUserG.grade
        introductionTextView.text = currentUserG.introduction
        //pickerView1.selectRow(getSelectionNum(selesction: user_.studentParameter?.selection), inComponent: 0, animated: false)
        //choiceTextField.text = user_.teacherParameter?.choice
        
        selectionTextField.text = currentUserG.selection
        
        userImageView.image = userImagesCacheG[currentUserG.userId]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let size = NSData(data: selectedImage.pngData()!).count.d
        let scale = Float(sqrt(min(1.d, 90000.d / size)))
        let resizedImage = selectedImage.scale(byFactor: scale)
        
        picker.dismiss(animated: true, completion: nil)
        
        let data = UIImage.pngData(resizedImage!)
        let file = NCMBFile.file(withName: currentUserG.userId, data: data()) as! NCMBFile
        file.saveInBackground { (error) in
            if error != nil{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            } else {
                self.userImageView.image = selectedImage
                userImagesCacheG[currentUserG.userId] = resizedImage
                self.imageName = currentUserG.userId
            }
        } progressBlock: { (progress) in
            print(progress)
        }
        
    }
  

    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bunri.count
        
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bunri[row]
        
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            selected = bunri[row]
        } else {
            selected = nil
        }
    }

    
    @IBAction func closeEditViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveUserInfo(){
        let param = currentUserG.teacherParameter!.ncmb
        let im = param.object(forKey: "imageName")
        if im == nil{
            param.setObject(imageName, forKey: "imageName")
        }
        param.setObject(userIdTextField.text, forKey: "userName")
        param.setObject(userIdFuriganaTextField.text, forKey: "furigana")
        param.setObject(gradeTextField.text, forKey: "grade")
        param.setObject(userIdTextField.text, forKey: "userName")
        param.setObject(userIdFuriganaTextField.text, forKey: "furigana")
        param.setObject(selectionTextField.text, forKey: "selection")
        if(selected != nil){
            param.setObject(selected!, forKey: "selection")
        }
        param.setObject(introductionTextView.text, forKey: "introduction")

        for k in kamokuCheckBoxList{
            for c in k.checkBoxes{
                if c.isSelected{
                    param.setObject(true, forKey: "isAbleToTeach" + c.key.upHead)
                } else {
                    param.setObject(false, forKey: "isAbleToTeach" + c.key.upHead)
                }
            }
        }
        
        var youbi = ""
        let youbiList = ["Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        for i in 0..<youbiCheckBoxList.count {
            param.setObject(youbiCheckBoxList[i].selectedKeys, forKey: youbiList[i]+"Time")
            if youbiCheckBoxList[i].selectedKeys.count == 0 {
                youbi += "F"
            } else {
                youbi += "T"
            }
        }
        param.setObject(youbi, forKey: "youbi")
        

        param.saveInBackground { (error) in
            if error == nil{
                currentUserG = User(NCMBUser.current()!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        }

        
    }
    
    @IBAction func selectImage() {
        let actionController = UIAlertController(title: "画像の選択", message: "選択して下さい", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            //カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                self.showOkAlert(title: "エラー", message: "この機種ではカメラが使用出来ません。")
            }
        }
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            //アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                self.showOkAlert(title: "エラー", message: "この機種ではフォトライブラリが使用出来ません。")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func selectWeek(){
        var alertOkActionList = [UIAlertAction(title: "終了", style: .cancel) { (action) in
            self.youbiAlertController.dismiss(animated: true, completion: nil)
        }]
        for i in 0..<youbiList_.count{
            alertOkActionList.append( makeAlertAction2(i) )
        }
        if youbiAlertController.actions.count == 0{
            for action in alertOkActionList{
                youbiAlertController.addAction(action)
            }
        }
        self.present(youbiAlertController, animated: true, completion: nil)
    }
    
    @IBAction func selectclass(){
        var alertOkActionList = [UIAlertAction(title: "終了", style: .cancel) { (action) in
            self.kamokuCheckBox.mainView.removeFromSuperview()
            self.kamokuAlertController.dismiss(animated: true, completion: nil)
        }]
        for i in 0..<kamokuList.count{
            alertOkActionList.append( makeAlertAction(i) )
        }
        if kamokuAlertController.actions.count == 0{
            for action in alertOkActionList{
                kamokuAlertController.addAction(action)
            }
        }
        self.present(kamokuAlertController, animated: true, completion: nil)
    }
    
    func makeAlertAction(_ i : Int) -> UIAlertAction{
        let subjectList = ["国語", "数学", "理科", "社会", "英語"]
        return UIAlertAction(title: subjectList[i], style: .default) { (action) in
            self.kamokuAlertController.dismiss(animated: true, completion: nil)
            self.selectDetailClass(i)
        }
    }
    
    func makeAlertAction2(_ i : Int) -> UIAlertAction{
        let youbiList = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]
        return UIAlertAction(title: youbiList[i], style: .default) { (action) in
            self.youbiAlertController.dismiss(animated: true, completion: nil)
            self.selectDetailYoubi(i)
        }
    }

    
    func selectDetailClass(_ i : Int) {
        let alertController = UIAlertController(title: "科目を選んでください。", message: "\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "他の教科も設定する", style: .default) { (action) in
            self.kamokuCheckBoxList[i].mainView.removeFromSuperview()
            alertController.dismiss(animated: true, completion: nil)
            self.present(self.kamokuAlertController, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "選択完了", style: .default) { (action) in
            self.kamokuCheckBoxList[i].mainView.removeFromSuperview()
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.view.addSubview(kamokuCheckBoxList[i].mainView)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func selectDetailYoubi(_ i : Int) {
        var message = ""
        if i < 5 {
            message = "\n\n\n\n\n\n"
        } else {
            message = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
        }
        let alertController = UIAlertController(title: "時間帯を選んでください。", message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "他の曜日も設定する", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            self.present(self.youbiAlertController, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "選択完了", style: .default) { (action) in
            self.youbiCheckBoxList[i].mainView.removeFromSuperview()
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.view.addSubview(youbiCheckBoxList[i].mainView)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getSelectionNum(selesction: String?) -> Int {
        if(selesction == nil){
            return 0
        }
        let i = bunri.firstIndex(of: selesction!)
        if i == nil {
            return 0
        }
        return i!
    }

}
