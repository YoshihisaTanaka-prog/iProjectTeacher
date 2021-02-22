//
//  ForgetPasswordViewController.swift
//  iProjectTeacher
//
//  Created by Kaori Nakamura on 2/20/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var ForgetemailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ForgetemailTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    @IBAction func signUp() {
    
        let Forgetemail = ForgetemailTextField.text

        NCMBUser.requestPasswordResetForEmail(inBackground: Forgetemail, block: {(error) in
          if (error != nil) {
            print(error);
          } else {
            print("メール送信完了")
          }
        })

    
}

}
