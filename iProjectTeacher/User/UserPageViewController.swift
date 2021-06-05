//
//  UserpageViewController.swift
//  iProjectTeacher
//
//  Created by Ryusei Hiraoka on 2021/02/12.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class UserPageViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var userImageView: UIImageView!
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var userIdFuriganaTextField: UITextField!
    @IBOutlet var schoolTextField: UITextField!
    @IBOutlet var gradeTextField: UITextField!
    //@IBOutlet var choiceTextField: UITextField!
    @IBOutlet var selectionTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    //@IBOutlet var parentsEmailTextField: UITextField!
    @IBOutlet var introductionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        setBackGround(true, true)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        userIdTextField.delegate = self
        userIdFuriganaTextField.delegate = self
        schoolTextField.delegate = self
        gradeTextField.delegate = self
        //choiceTextField.delegate = self
        emailTextField.delegate = self
        //parentsEmailTextField.delegate = self
//        pickerView1.delegate = self
//        pickerView1.dataSource = self
        introductionTextView.delegate = self
        
        //let userIdFurigana = NCMBUser.current()?.setObject(userIdFuriganaTextField.text, forKey: "furigana") as! String
        //let Introduction = NCMBUser.current()?.setObject(introductionTextView.text, forKey: "introduction") as! String
        //userIdTextField.text = userId
        userIdTextField.text = currentUserG.userName
        emailTextField.text = currentUserG.mailAddress
        userIdFuriganaTextField.text = currentUserG.furigana
        schoolTextField.text = currentUserG.teacherParameter?.collage
        
        gradeTextField.text = transformGrade(currentUserG.grade)
        //choiceTextField.text = user.teacherParameter?.choice
        selectionTextField.text = currentUserG.teacherParameter?.selection
        //parentsEmailTextField.text = user.studentParameter?.parentEmailAdress
        introductionTextView.text = currentUserG.teacherParameter?.introduction
        userImageView.image = userImagesCacheG[currentUserG.ncmb.objectId]
    }
    
    private func transformGrade(_ grade: String) -> String {
        let grades = grade.ary
        var gradeText = "？？？？？"
        if( grades.count != 0 ){
            switch grades[0] {
            case "E":
                gradeText = "小学 "
            case "J":
                gradeText = "中学 "
            case "H":
                gradeText = "高校・高専"
            case "R":
                gradeText = "浪人生"
            case "B":
                gradeText = "学部 "
            case "M":
                gradeText = "修士 "
            case "D":
                gradeText = "博士 "
            default:
                break
            }
            if grades.count != 1{
                gradeText += grades[1] + "年生"
            }
        }
        return gradeText
    }
    
    @IBAction func showMenu(){
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択して下さい。", preferredStyle: .actionSheet)
        let  signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground { (error) in
                if error != nil {
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    //ログアウト成功
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(identifier: "RootNavigationController")
                    
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        
            }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}