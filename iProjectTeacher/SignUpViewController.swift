//
//  SignUpViewController.swift
//  iProjectTeacher
//
//  Created by Ryusei Hiraoka on 2021/01/31.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var departmentTextField: UITextField!
    @IBOutlet var emailunivTextField: UITextField!
    @IBOutlet var subjectTextField: UITextField!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        NameTextField.delegate = self
        departmentTextField.delegate = self
        emailunivTextField.delegate = self
        subjectTextField.delegate = self
        userIdTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUp() {
        if checkDomain(emailunivTextField.text!) {
            let user = NCMBUser()
            
            user.userName = NameTextField.text!
//    //        こうすることでメールを用いた本人確認ができるらしい。そのほかのデータ（名前、学部などをどうするのかについては考え中）
//            var error: NSError? = nil
//            NCMBUser.requestAuthenticationMail(emailunivTextField.text!, error: &error)
//            if(error == nil){
//                showOkAlert(title: "報告", message: "確認メールを送信いたします。")
//            }
//            else{
//                showOkAlert(title: "Error", message: error!.localizedDescription)
//            }
        }
        else{
            
        }
    }

}

extension SignUpViewController{
    func checkDomain(_ mailAdress: String) -> Bool {
        //ここは背景が作ります。
        let partition = mailAdress.components(separatedBy: "@")
        if(partition.count == 1){
            showOkAlert(title: "エラー", message: "メールアドレスが入力されていません。")
            return false
        }
        if(false){
            showOkAlert(title: "エラー", message: "「" + emailunivTextField.text! + "」は未登録のドメインが含まれています。確認作業を行いますのでしばらくお待ちください。")
            return false
        }
        return true
    }
}
