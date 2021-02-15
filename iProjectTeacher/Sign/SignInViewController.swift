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
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
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
        
        if (emailTextField.text?.count)! > 0 &&
            (passwordTextField.text?.count)! > 0 {
        NCMBUser.logInWithMailAddress(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
       
            if error != nil {
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }else{
                //ログイン成功
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                
                //ログインの保持
                let ud = UserDefaults.standard
                let mail = user!.mailAddress!
                if( ud.bool(forKey: mail + "isNeedToInputData") ){
                    
                    //ACLオブジェクトを作成
                    let acl = NCMBACL()
                    //読み込み・検索を全開放
                    acl.setPublicReadAccess(true)
                    acl.setPublicWriteAccess(false)
                    acl.setReadAccess(true, for: user)
                    acl.setWriteAccess(true, for: user)
                    user?.acl = acl
                    
                    user?.userName = ud.string(forKey: mail + "name")
                    user?.setObject(ud.string(forKey: mail + "furigana") , forKey: "furigana")
                    user?.setObject(true, forKey: "isTeacher")
                    user?.setObject(true, forKey: "isActive")
                    user?.setObject(nil, forKey: "peerId")
                    user?.saveInBackground({ (error) in
                        if(error == nil){
                            let object = NCMBObject(className: "TeacherParameter")
                            object?.setObject(ud.string(forKey: mail + "departments"), forKey: "departments")
                            object?.setObject(user, forKey: "user")
                            let collage = ud.object(forKey: mail + "collage") as! String
                            object?.setObject(collage, forKey: "collage")
                            object?.saveInBackground({ (error) in
                                if(error == nil){
                                    user?.setObject(object, forKey: "parameter")
                                    user?.saveInBackground({ (error) in
                                        if(error != nil){
                                            self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                        }
                                    })
                                }
                                else{
                                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                }
                            })
                        }
                        else{
                            self.showOkAlert(title: "Error", message: error!.localizedDescription)
                        }
                    })
                }
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
            }
            
        }
    }


}
}
