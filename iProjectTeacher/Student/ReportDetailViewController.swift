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

class ReportDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var userIdFuriganaTextField: UITextField!
    @IBOutlet var tangenTextField: UITextField!
    @IBOutlet var pickerView1: UIPickerView!
    @IBOutlet var homeworkTextView: UITextView!
    @IBOutlet var nextplanTextView: UITextView!
    @IBOutlet var pearentMessageTextView: UITextView!
    @IBOutlet var otherTeachersMessageTextView: UITextView!


    var selected: String?
    let hyouka = ["生徒の授業態度を選択してください","大変良い","まあまあ良い","普通","やや改善が必要","改善が必要"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround(true, true)
        
//        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
//        userImageView.layer.masksToBounds = true
        
        userIdTextField.delegate = self
        userIdFuriganaTextField.delegate = self
        tangenTextField.delegate = self
        pickerView1.delegate = self
        pickerView1.dataSource = self
        homeworkTextView.delegate = self
        nextplanTextView.delegate = self
        pearentMessageTextView.delegate = self
        otherTeachersMessageTextView.delegate = self
        
        let object = NCMBObject(className: "Reports")

        userIdTextField.text = ""
        userIdFuriganaTextField.text = ""
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
        let object = NCMBObject(className: "Report")
        object?.setObject(userIdTextField.text, forKey: "studentName")
        object?.setObject(userIdFuriganaTextField.text, forKey: "studentNameFurigana")
        object?.setObject(tangenTextField.text, forKey: "tangen")
        object?.setObject(homeworkTextView.text, forKey: "homework")
        object?.setObject(nextplanTextView.text, forKey: "nextplan")
        object?.setObject(pearentMessageTextView.text, forKey: "pearentMessage")
        object?.setObject(otherTeachersMessageTextView.text, forKey: "otherTeachersMessage")
        if(selected != nil){
            object?.setObject(selected!, forKey: "attitude")
        }

        object?.saveInBackground{ (error) in
            if error != nil {
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            } else {

            }
        }
        
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
