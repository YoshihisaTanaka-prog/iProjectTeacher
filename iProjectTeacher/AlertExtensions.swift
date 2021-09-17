//
//  AlertExtensions.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/06/04.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

extension UIViewController{
    func showOkAlert(title: String, message: String) {
        showOkAlert(title: title, message: message) {}
    }
    
    func showOkAlert(title: String, message: String, okAction: @escaping () -> Void ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            okAction()
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertOkAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showOkCancelAlert(title: String, message: String, okAction: @escaping () -> Void ,cancelAction: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            okAction()
            alertController.dismiss(animated: true, completion: nil)
        }
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            cancelAction()
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertOkAction)
        alertController.addAction(alertCancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func blockUserAlert(user: User){
        blockUserAlert(userId: user.userId, chatRoomId: user.chatRoomId, afterAction: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func blockUserAlert(userId: String, chatRoomId: String, afterAction: @escaping () -> Void ){
        if userId != ""{
            let alert = UIAlertController(title: "確認", message: "このユーザーをブロックしますか？", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "はい", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
                if reportedDataG["User"] == nil{
                    reportedDataG["User"] = [userId]
                } else if !reportedDataG["User"]!.contains(userId){
                    reportedDataG["User"]!.append(userId)
                }
                if reportedDataG["ChatRoom"] == nil{
                    reportedDataG["ChatRoom"] = [chatRoomId]
                } else if !reportedDataG["ChatRoom"]!.contains(chatRoomId) {
                    reportedDataG["ChatRoom"]!.append(chatRoomId)
                }
                NCMBUser.current()?.setObject(reportedDataG, forKey: "reportInfo")
                NCMBUser.current().saveInBackground { error in
                    if error == nil{
                        self.reportToRailsServer(className: "User", objectId: userId)
                        afterAction()
                    }
                }
            }
            let noAction = UIAlertAction(title: "いいえ", style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
