//
//  EditUserPageViewController.swift
//  iProjectTeacher
//
//  Created by Ring Trap on 2/24/21.
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

    var selected: String?
    let bunri = ["文理選択","文系","理系","その他"]
    var youbiCheckBox: CheckBox!
    var kamokuCheckBox: CheckBox!
    let youbiList: [CheckBoxInput] = [
        CheckBoxInput("月曜日"),
        CheckBoxInput("火曜日"),
        CheckBoxInput("水曜日"),
        CheckBoxInput("木曜日"),
        CheckBoxInput("金曜日"),
        CheckBoxInput("土曜日", color: .blue),
        CheckBoxInput("日曜日", color: .red)
    ]
    let kamokuList: [CheckBoxInput] = [
        CheckBoxInput("国語"),
        CheckBoxInput("数学"),
        CheckBoxInput("英語"),
        CheckBoxInput("社会"),
        CheckBoxInput("理科")
        //CheckBoxInput("土曜日", color: .blue),
        //CheckBoxInput("日曜日", color: .red)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGround(true, true)
        
        youbiCheckBox = CheckBox(youbiList,size: CGRect(x: 0, y: 0, width: 0, height: 0))
        kamokuCheckBox = CheckBox(kamokuList,size: CGRect(x: 0, y: 0, width: 0, height: 0))
        
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
        
        let mailAddress_ = NCMBUser.current()?.mailAddress
        let user_ = User(NCMBUser.current())
        userIdTextField.text = user_.userName
        emailTextField.text = mailAddress_
        userIdFuriganaTextField.text = user_.userIdFurigana
        schoolTextField.text = user_.teacherParameter?.SchoolName
        //gradeTextField.text = user_.teacherParameter?.grade
        gradeTextField.text = user_.grade
        introductionTextView.text = user_.teacherParameter?.introduction
        //pickerView1.selectRow(getSelectionNum(selesction: user_.studentParameter?.selection), inComponent: 0, animated: false)
        //choiceTextField.text = user_.teacherParameter?.choice
        
        selectionTextField.text = user_.teacherParameter?.selection
        
        userImageView.image = userImagesCacheG[NCMBUser.current()!.objectId]
        
        youbiCheckBox.setSelection(user_.teacherParameter!.youbi)
        kamokuCheckBox.setSelection(user_.teacherParameter!.kamoku)
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
        let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: data()) as! NCMBFile
        file.saveInBackground { (error) in
            if error != nil{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            } else {
                self.userImageView.image = selectedImage
                userImagesCacheG[NCMBUser.current()!.objectId] = selectedImage
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
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return bunri.count
        
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return bunri[row]
        
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
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
        let user = User(NCMBUser.current())
        user.ncmb.setObject(userIdTextField.text, forKey: "name")
        user.teacherParameter!.ncmb.setObject(userIdTextField.text, forKey: "userName")
        user.ncmb.setObject(userIdFuriganaTextField.text, forKey: "furigana")
        user.teacherParameter!.ncmb.setObject(userIdFuriganaTextField.text, forKey: "furigana")
        user.teacherParameter!.ncmb.setObject(schoolTextField.text, forKey: "SchoolName")
        user.ncmb.setObject(gradeTextField.text, forKey: "grade")
        //user.studentParameter!.ncmb.setObject(gradeTextField.text, forKey: "grade")
        //user.teacherParameter!.ncmb.setObject(choiceTextField.text, forKey: "choice")
        user.teacherParameter!.ncmb.setObject(selectionTextField.text, forKey: "selection")
        if(selected != nil){
            user.teacherParameter!.ncmb.setObject(selected!, forKey: "selection")
        }
        user.ncmb.mailAddress = emailTextField.text
        user.teacherParameter!.ncmb.setObject(introductionTextView.text, forKey: "introduction")
        user.teacherParameter!.ncmb.setObject(youbiCheckBox.getSelection(), forKey: "youbi")
        user.ncmb.saveInBackground{ (error) in
            if error != nil {
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            } else {
                user.teacherParameter!.ncmb.saveInBackground { (error) in
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
        let alertController2 = UIAlertController(title: "科目を選んでください。", message: "\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let alertOkAction2 = UIAlertAction(title: "選択完了", style: .default) { (action) in
            self.youbiCheckBox.mainView.removeFromSuperview()
            alertController2.dismiss(animated: true, completion: nil)
        }
        let width = alertController2.view.frame.width
        youbiCheckBox.mainView.frame = CGRect(x: width / 10.f, y: 50, width: width * 0.8, height: youbiCheckBox.height)
        alertController2.view.addSubview(youbiCheckBox.mainView)
        alertController2.addAction(alertOkAction2)
        self.present(alertController2, animated: true, completion: nil)
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
