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
        selectionTextField.text = currentUserG.selection
        //parentsEmailTextField.text = user.studentParameter?.parentEmailAdress
        introductionTextView.text = currentUserG.introduction
        userImageView.image = userImagesCacheG[currentUserG.userId]
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
