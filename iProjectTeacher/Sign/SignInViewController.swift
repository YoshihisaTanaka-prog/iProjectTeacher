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
        setBackGround(true, false)

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
        
        if passwordTextField.text!.count > 0 {
            NCMBUser.logInWithMailAddress(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil{
                    //エラーがあった場合
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    //ログイン成功
                    let p = user?.object(forKey:"parameter") as? NCMBObject
                    if p == nil {
                        // 初回ログイン
                        user!.acl = nil
                        user?.saveInBackground({ (error) in
                            if(error == nil){
                                let storyboard = UIStoryboard(name: "Questionnaire", bundle: Bundle.main)
                                let rootViewController = storyboard.instantiateViewController(withIdentifier: "QuestionnaireController")
                                self.present(rootViewController, animated: false, completion: nil)
                                
                                //ログイン状態の保持
                                let ud = UserDefaults.standard
                                ud.set(true, forKey: "isLogin")
                                ud.set(self.passwordTextField.text!, forKey: self.emailTextField.text!)
                                ud.set(Date(), forKey: self.emailTextField.text! + "time")
                                ud.synchronize()
                            }
                            else{
                                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                            }
                        })
                    } else {
                        //２回目以降のログイン
                        currentUserG = User(userId: user!.objectId, isNeedParameter: true, viewController: self)
                        if( p!.ncmbClassName == "StudentParameter" ){
                            //生徒垢の場合
                            NCMBUser.logOutInBackground { (error) in
                                if error != nil {
                                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                } else {
                                    self.showOkAlert(title: "注意", message: "このアカウントは生徒用のアカウントとして登録されています。\n教師用アカウントと生徒用アカウントは併用することができません。")
                                }
                            }
                        } else {
                            //教師垢の場合
                            self.loadFollowList()
                            let alertController = UIAlertController(title: "ユーザ情報取得中", message: "しばらくお待ちください。", preferredStyle: .alert)
                            self.present(alertController, animated: true, completion: nil)
                            //画像のダウンロードに時間がかかるので、2秒待機
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                alertController.dismiss(animated: true, completion: nil)
                                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                                self.present(rootViewController, animated: true, completion: nil)
                            }
                            //ログイン状態の保持
                            let ud = UserDefaults.standard
                            ud.set(true, forKey: "isLogin")
                            ud.set(self.passwordTextField.text!, forKey: self.emailTextField.text!)
                            ud.set(Date(), forKey: self.emailTextField.text! + "time")
                            ud.synchronize()
                        }
                    }
                }
            }
        }
    }
}
