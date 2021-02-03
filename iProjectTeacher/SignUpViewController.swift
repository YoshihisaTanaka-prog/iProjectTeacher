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
        let user = NCMBUser()
        
        user.userName = NameTextField.text!
    }


}
