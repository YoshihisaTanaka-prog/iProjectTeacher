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
    @IBOutlet var furiganaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NameTextField.delegate = self
        departmentTextField.delegate = self
        emailunivTextField.delegate = self
        furiganaTextField.delegate = self
        
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
    //        こうすることでメールを用いた本人確認ができるらしい。そのほかのデータ（名前、学部などをどうするのかについては考え中）
            var error: NSError? = nil
            let mail = emailunivTextField.text!
            NCMBUser.requestAuthenticationMail(mail, error: &error)
            if(error == nil){
                showOkAlert(title: "報告", message: "確認メールを送信いたします。")
                let ud = UserDefaults.standard
                ud.set(true, forKey: mail + "isNeedToInputData")
                ud.set(departmentTextField.text!, forKey: mail + "departments")
                ud.set(NameTextField.text!, forKey: mail + "name")
                ud.set(furiganaTextField.text!, forKey: mail + "furigana")
                ud.synchronize()
            }
            else{
                showOkAlert(title: "Error", message: error!.localizedDescription)
            }
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
