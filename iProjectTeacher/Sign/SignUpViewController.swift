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
    
    var domainList = Domains()
    var wrongDomainList = Domains()
    
    //@IBOutlet var NameTextField: UITextField!
    //@IBOutlet var departmentTextField: UITextField!
    @IBOutlet var emailunivTextField: UITextField!
    //@IBOutlet var furiganaTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround(true, false)
        
        loadDomain()

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
    
    @IBAction func signUp() {
        if checkDomain(emailunivTextField.text!) {
            var error: NSError? = nil
            let mail = emailunivTextField.text!
            NCMBUser.requestAuthenticationMail(mail, error: &error)
            if(error == nil){
                self.showOkDismissAlert(title: "報告", message: "本人確認用のメールアドレスを送信いたします。しばらくお待ちください。")
                
                let ud = UserDefaults.standard
                ud.set(true, forKey: mail + "isNeedToInputData")
                //ud.set(departmentTextField.text!, forKey: mail + "departments")
                //ud.set(NameTextField.text!, forKey: mail + "name")
                //ud.set(furiganaTextField.text!, forKey: mail + "furigana")
                ud.synchronize()
                let domain = emailunivTextField.text!.components(separatedBy: "@").last!
//                domainList.set(domain: domain, mail: emailunivTextField.text!)
            }
            else{
                showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        }
        
        }
        
    }


