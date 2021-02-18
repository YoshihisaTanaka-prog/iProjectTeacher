//
//  CheckAddress.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/02/08.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit
import NCMB

extension SignUpViewController{
    
    func checkDomain(_ mailAdress: String) -> Bool {
        let partition = mailAdress.components(separatedBy: "@")
        if(partition.count != 2){
            showOkAlert(title: "エラー", message: "有効なメールアドレスが入力されていません。")
            return false
        }
        if(domainList.contains(partition.last!)){
            return true
        }
        else if(wrongDomainList.contains(partition.last!)){
            showOkAlert(title: "エラー", message: "無効なメールアドレスです。")
            emailunivTextField.text = ""
            return false
        }
        else{
            var error: NSError? = nil
            let mail = emailunivTextField.text!
            NCMBUser.requestAuthenticationMail(mail, error: &error)
            if(error == nil){
                self.showOkDismissAlert(title: "報告", message: "本人確認用のメールアドレスを送信いたしますが、\n「" + emailunivTextField.text! + "」には未登録のドメインが含まれています。確認作業を行いますので、ユーザー登録完了後しばらくお待ちください。")
                
                let object = NCMBObject(className: "Domain")
                object?.setObject(partition.last!, forKey: "domain")
                object?.setObject(false, forKey: "checked")
                object?.setObject("", forKey: "collage")
                object?.setObject(false, forKey: "parmitted")
                object?.setObject("", forKey: "prefecture")
                object?.setObject("", forKey: "shortenCollege")
                object?.saveInBackground({ (error) in
                    if(error == nil){
                        self.send()
                    }
                    else{
                        self.showOkAlert(title: "Error", message: error!.localizedDescription)
                    }
                })
                
                let ud = UserDefaults.standard
                ud.set(true, forKey: mail + "isNeedToInputData")
                ud.set(departmentTextField.text!, forKey: mail + "departments")
                ud.set(NameTextField.text!, forKey: mail + "name")
                ud.set(furiganaTextField.text!, forKey: mail + "furigana")
                ud.synchronize()
//                let domain = emailunivTextField.text!.components(separatedBy: "@").last!
//                domainList.set(domain: domain, mail: emailunivTextField.text!)
            }
         else{
              showOkAlert(title: "Error", message: error!.localizedDescription)
            }

            return false
        }
    }
    
    func loadDomain(){
        let query = NCMBQuery(className: "Domain")
        query?.findObjectsInBackground({ (result, error) in
            if(error == nil){
                let objects = result as! [NCMBObject]
                for object in objects {
                    let isChecked = object.object(forKey: "checked") as! Bool
                    if(isChecked){
                        let parmitted = object.object(forKey: "parmitted") as? Bool
                        if(parmitted != nil){
                            if(parmitted!){
                                self.domainList.add(object)
                            }
                            else{
                                self.wrongDomainList.add(object)
                            }
                        }
                    }
                }
                print(self.domainList.domainList, self.wrongDomainList.domainList)
                domainListG = self.domainList
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
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
    
    func send(){}
}

class Domains{
    var domainList: [String] = []
    var collageList: [String] = []
    var prefectureList: [[String]] = []
    
    func add(_ domainObject: NCMBObject) {
        let domain = domainObject.object(forKey: "domain") as! String
        if(domainList.contains(domain)){
            let index = domainList.firstIndex(of: domain)!
            let prefecture = domainObject.object(forKey: "prefecture") as! String
            prefectureList[index].append(prefecture)
        }
        else{
            let collage = domainObject.object(forKey: "collage") as! String
            let prefecture = domainObject.object(forKey: "prefecture") as! String
            domainList.append(domain)
            collageList.append(collage)
            prefectureList.append([prefecture])
        }
    }
    
    func getGollage(domain: String) -> String {
        let i = self.domainList.firstIndex(of: domain)
        if i == nil {
            return ""
        }
        return self.collageList[i!]
    }
    
    func contains(_ domain: String) -> Bool {
        return self.domainList.contains(domain)
    }
}
