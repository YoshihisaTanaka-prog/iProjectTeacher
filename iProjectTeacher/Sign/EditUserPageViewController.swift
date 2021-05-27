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
    //@IBOutlet var parentsEmailTextField: UITextField!
    @IBOutlet var selectionTextField: UITextField!
    //@IBOutlet var choiceTextField: UITextField!
    //@IBOutlet var pickerView1: UIPickerView!
    @IBOutlet var introductionTextView: UITextView!
    
    let kamokuAlertController = UIAlertController(title: "教科を選んでください。", message: "", preferredStyle: .actionSheet)

    var selected: String?
    let bunri = ["文理選択","文系","理系","その他"]
    var youbiCheckBox: CheckBox!
    var kamokuCheckBoxList: [CheckBox] = []
    let youbiList: [CheckBoxInput] = [
        CheckBoxInput("月曜日"),
        CheckBoxInput("火曜日"),
        CheckBoxInput("水曜日"),
        CheckBoxInput("木曜日"),
        CheckBoxInput("金曜日"),
        CheckBoxInput("土曜日", color: .blue),
        CheckBoxInput("日曜日", color: .red)
    ]
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
            CheckBoxInput("英語", key: "English")
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGround(true, true)
        
        youbiCheckBox = CheckBox(youbiList,size: CGRect(x: 0, y: 0, width: 0, height: 0))
        youbiCheckBox.setSelection(currentUserG.teacherParameter!.youbi)
        
        for i in 0..<kamokuList.count{
            let kamokuCheckBox = CheckBox(kamokuList[i],size: CGRect(x: 0, y: 0, width: 0, height: 0))
            kamokuCheckBox.setSelectedKey(currentUserG.teacherParameter!.kamokuList[i])
            kamokuCheckBoxList.append(kamokuCheckBox)
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
        userIdFuriganaTextField.text = currentUserG.userIdFurigana
        schoolTextField.text = currentUserG.teacherParameter?.SchoolName
        //gradeTextField.text = user_.teacherParameter?.grade
        gradeTextField.text = currentUserG.grade
        introductionTextView.text = currentUserG.teacherParameter?.introduction
        //pickerView1.selectRow(getSelectionNum(selesction: user_.studentParameter?.selection), inComponent: 0, animated: false)
        //choiceTextField.text = user_.teacherParameter?.choice
        
        selectionTextField.text = currentUserG.teacherParameter?.selection
        
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
                userImagesCacheG[currentUserG.userId] = selectedImage
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
        let user = currentUserG.ncmb
        let param = currentUserG.teacherParameter!.ncmb
        user.setObject(userIdTextField.text, forKey: "name")
        user.setObject(userIdFuriganaTextField.text, forKey: "furigana")
        user.setObject(gradeTextField.text, forKey: "grade")
        param.setObject(userIdTextField.text, forKey: "userName")
        param.setObject(userIdFuriganaTextField.text, forKey: "furigana")
        param.setObject(schoolTextField.text, forKey: "SchoolName")
        //user.studentParameter!.ncmb.setObject(gradeTextField.text, forKey: "grade")
        //user.teacherParameter!.ncmb.setObject(choiceTextField.text, forKey: "choice")
        param.setObject(selectionTextField.text, forKey: "selection")
        if(selected != nil){
            param.setObject(selected!, forKey: "selection")
        }
//        user.mailAddress = emailTextField.text
        param.setObject(introductionTextView.text, forKey: "introduction")
        param.setObject(youbiCheckBox.selectionText, forKey: "youbi")
        for k in kamokuCheckBoxList{
            for c in k.checkBoxes{
                if c.isSelected{
                    param.setObject(true, forKey: "isAbleToTeach" + c.key.upperHead)
                } else {
                    param.setObject(false, forKey: "isAbleToTeach" + c.key.upperHead)
                }
            }
        }
        user.saveInBackground{ (error) in
            if error != nil {
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            } else {
                param.saveInBackground { (error) in
                    if error == nil{
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        self.showOkAlert(title: "Error", message: error!.localizedDescription)
                    }
                }
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
        let alertController = UIAlertController(title: "曜日を選んでください。", message: "\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "選択完了", style: .default) { (action) in
            self.youbiCheckBox.mainView.removeFromSuperview()
            alertController.dismiss(animated: true, completion: nil)
        }
        let width = alertController.view.frame.width
        youbiCheckBox.mainView.frame = CGRect(x: width / 10.f, y: 50, width: width * 0.8, height: youbiCheckBox.height)
        alertController.view.addSubview(youbiCheckBox.mainView)
        alertController.addAction(alertOkAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func selectclass(){
        var alertOkActionList = [UIAlertAction(title: "終了", style: .cancel) { (action) in
            self.youbiCheckBox.mainView.removeFromSuperview()
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
        
        let width = alertController.view.frame.width
        kamokuCheckBoxList[i].mainView.frame = CGRect(x: width / 10.f, y: 50, width: width * 0.8, height: kamokuCheckBoxList[i].height)
        alertController.view.addSubview(kamokuCheckBoxList[i].mainView)
        
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
