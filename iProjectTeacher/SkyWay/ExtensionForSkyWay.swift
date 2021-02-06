//
//  ExtensionForSkyWay.swift
//  skyway-ncmb
//
//  Created by 田中義久 on 2021/02/01.
//

import Foundation
import UIKit
import NCMB

extension UIViewController{
    
    func goToVideoPhone(_ userId: String){
        print(userId)
        let storyboard = UIStoryboard(name: "VideoPhone", bundle: Bundle.main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "VideoPhone") as! MediaConnectionViewController
        rootViewController.userId = userId
        rootViewController.view.backgroundColor = .white
        self.present(rootViewController, animated: true, completion: nil)
    }
    
    func setAppFinishIvent(){
        let notificationCenter1 = NotificationCenter.default
        notificationCenter1.addObserver(
            self,
            selector: #selector(self.finnished),
            name:UIApplication.willTerminateNotification,
            object: nil)
        let notificationCenter2 = NotificationCenter.default
        notificationCenter2.addObserver(
            self,
            selector: #selector(self.finnished),
            name:UIApplication.didEnterBackgroundNotification,
            object: nil)
    }
    
    @objc private func finnished(){
        let user = NCMBUser.current()!
        user.setObject(nil, forKey: "peerId")
        user.setObject(Date(), forKey: "logOutTime")
        let error = NSErrorPointer(nilLiteral: ())
        user.save(error)
    }
    
}
