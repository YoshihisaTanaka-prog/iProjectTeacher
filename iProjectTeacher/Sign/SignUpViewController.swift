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
    
    //@IBOutlet var NameTextField: UITextField!
    //@IBOutlet var departmentTextField: UITextField!
    @IBOutlet var emailunivTextField: UITextField!
    //@IBOutlet var furiganaTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround(true, false)

        //NameTextField.delegate = self
        //departmentTextField.delegate = self
        emailunivTextField.delegate = self
        //furiganaTextField.delegate = self

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showOkDismissAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alertOkAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUp() {
        var error: NSError? = nil
        let mail = emailunivTextField.text!
        NCMBUser.requestAuthenticationMail(mail, error: &error)
        if(error == nil){
            self.showOkDismissAlert(title: "報告", message: "本人確認用のメールアドレスを送信いたします。しばらくお待ちください。")
        }
        else{
            showOkAlert(title: "Error", message: error!.localizedDescription)
        }
    }
    
}


