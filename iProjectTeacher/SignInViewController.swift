//
//  SignInViewController.swift
//  iProjectTeacher
//
//  Created by Ryusei Hiraoka on 2021/01/31.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        NameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn() {
        
        if (NameTextField.text?.count)! > 0 &&
            (passwordTextField.text?.count)! > 0 {
        NCMBUser.logInWithUsername(inBackground: NameTextField.text!, password: passwordTextField.text!) { (user, error) in
       
            if error != nil {
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }else{
                //ログイン成功
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                
                //ログインの保持
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud .synchronize()
            }
            
        }
    }


}
}
