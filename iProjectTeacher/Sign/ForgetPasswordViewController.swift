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
        
        setBackGround(false, false)
        
        ForgetemailTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    @IBAction func signUp() {
    
        let Forgetemail = ForgetemailTextField.text?.lowercased()

        NCMBUser.requestPasswordResetForEmail(inBackground: Forgetemail, block: {(error) in
          if (error != nil) {
            self.showOkAlert(title: "Error", message: error!.localizedDescription)
          } else {
            self.showOkAlert(title: "メール送信完了", message: "パスワード変更の確認のためのメールを送信いたしました。")
          }
        })
    }
}
