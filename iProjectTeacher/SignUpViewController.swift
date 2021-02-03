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
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var univnameTextField: UITextField!
    @IBOutlet var departmentTextField: UITextField!
    @IBOutlet var emailunivTextField: UITextField!
    @IBOutlet var subjectTextField: UITextField!
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        univnameTextField.delegate = self
        departmentTextField.delegate = self
        emailunivTextField.delegate = self
        subjectTextField.delegate = self
        userTextField.delegate = self
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
    


}
