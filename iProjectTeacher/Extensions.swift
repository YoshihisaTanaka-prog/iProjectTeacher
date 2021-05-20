//
//  Extensions.swift
//  ChatTest
//
//  Created by 田中義久 on 2021/01/13.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit
import NCMB
import Kingfisher


extension Int{
    public var d: Double {
        return Double(self)
    }
    public var f: CGFloat {
        return CGFloat(self)
    }
    public var s: String {
        return String(self)
    }
}

extension Double{
    public var i: Int {
        return Int(self)
    }
    public var f: CGFloat {
        return CGFloat(self)
    }
    public var s: String {
        return String(self)
    }
}
extension String{
    public var sArray: [String] {
        let cArray = Array(self)
        var ret: [String] = []
        for c in cArray {
            ret.append(String(c))
        }
        return ret
    }
    
    public var upperHead: String{
        if self == ""{
            return self
        }
        let array = self.sArray
        var ret = array[0].uppercased()
        
        if self.count != 1{
            for i in 1..<array.count{
                ret += array[i]
            }
        }
        
        return ret
    }
}

extension UIViewController{
    func showOkAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertOkAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUserImage(_ imageView: inout UIImageView, _ user: User){
        if user.teacherParameter == nil{
            imageView.image = userImagesCacheG[user.userId] ?? UIImage(named: "studentNoImage.png")
        }
        else{
            imageView.image = userImagesCacheG[user.userId] ?? UIImage(named: "teacherNoImage.png")
        }
        if user.imageName != nil {
            if user.teacherParameter == nil{
                imageView.kf.setImage(with: URL(string: "https://mbaas.api.nifcloud.com/2013-09-01/applications/LEaF9q0Coe9T8EYl/publicFiles/" + user.userId), placeholder: userImagesCacheG[user.userId] ?? UIImage(named: "studentNoImage.png"))
            }
            else{
                imageView.kf.setImage(with: URL(string: "https://mbaas.api.nifcloud.com/2013-09-01/applications/LEaF9q0Coe9T8EYl/publicFiles/" + user.userId), placeholder: userImagesCacheG[user.userId] ?? UIImage(named: "teacherNoImage.png"))
            }
        }
    }
    
    func sendToRailsServer(message: String, path: String){
        print("https://telecture.herokuapp.com" + path)
        print(message)
        let url = URL(string: "https://telecture.herokuapp.com" + path)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ("token=fN4BnkumjMvnbZd47gFLYL7JpVn283eaZwxEpT8NYyhYMPUaRDzR3dQZxTUT2eQYz7gqG9UMjAm8VaM26fhH7ueN7fJbXPsfCpM8&" + message).data(using: .utf8)
        print(request)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                if let response = response as? HTTPURLResponse{
                    print("HTTP response >> " + response.statusCode.s )
                }
            } else{
                print("HTTP Request ERROR >> " + error!.localizedDescription)
            }
        }.resume()
    }
}

extension NCMBUser{
    func getParameter() -> NCMBObject? {
        let object = self.object(forKey: "parameter") as? NCMBObject
        return object
    }
}

extension NCMBObject{
    func getUser() -> NCMBUser?{
        if(["StudentParameter","TeacherParameter"].contains(self.ncmbClassName)){
            let user = self.object(forKey: "user") as? NCMBUser
            return user
        }
        return nil
    }
}

