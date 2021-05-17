//
//  User.swift
//  ChatTest
//
//  Created by 田中義久 on 2021/01/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//
import Foundation
import UIKit
import NCMB

class User {
    var ncmb: NCMBUser
    var userId: String
    var userName: String
    var userIdFurigana: String?
    var mailAddress: String?
    var grade: String?
    var imageName: String?
    var oneOnOneSerch: String
    var teacherParameter: TeacherParameter?
    var studentParameter: StudentParameter?
    
    
    
    init(_ user: NCMBUser) {
        
        self.ncmb = user
        self.userId = user.objectId
        self.userName = user.object(forKey: "userName") as! String
        self.imageName = user.object(forKey: "imageName") as? String
        self.mailAddress = user.mailAddress
        self.userIdFurigana = user.object(forKey: "furigana") as? String
        self.userName = user.object(forKey: "name") as? String ?? ""
        self.grade = user.object(forKey: "grade") as? String ?? ""
        
//        個人チャットを検索するためのパラメータ
        if (NCMBUser.current()?.objectId)! < self.userId {
            oneOnOneSerch = (NCMBUser.current()?.objectId)! + "-" + self.userId
        }
        else{
            oneOnOneSerch = self.userId + "-" + (NCMBUser.current()?.objectId)!
        }
        
//        ユーザの詳細データ
        let parameter = user.object(forKey: "parameter") as? NCMBObject
        if( parameter == nil ){
            self.userName = ""
            user.userName = ""
            var e: NSError? = nil
            user.save(&e)
        }
        else{
            let param = NCMBObject(className: parameter!.ncmbClassName, objectId: parameter!.objectId)
            var error: NSError? = nil
            param?.fetch(&error)
//                ここのif文の中身は生徒側のユーザクラスも変更お願いします。（教師側に合わせてください。）
            if(error == nil && param != nil){
                let isPermitted = param?.object(forKey: "isPermitted") as? Bool ?? false
                if(isPermitted){
                    if(param!.ncmbClassName == "TeacherParameter"){
                        self.teacherParameter = TeacherParameter(param!)
                        if(userImagesCacheG[self.userId] == nil){
                            userImagesCacheG[self.userId] = UIImage(named: "teacherNoImage.png")
                        }
                    }
                    else{
                        self.studentParameter = StudentParameter(param!)
                        if(userImagesCacheG[self.userId] == nil){
                            userImagesCacheG[self.userId] = UIImage(named: "studentNoImage.png")
                        }
                    }
                }
            }
        }
        
//        画像の設定
        let imageName = user.object(forKey: "imageName") as? String
        if( imageName != nil ){
            let file = NCMBFile.file(withName: imageName!, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil {
                    
                } else {
                    if data != nil {
                        let image = UIImage(data: data!)
                        userImagesCacheG[self.userId] = image
                    }
                }
            }
        }
    }
}

class TeacherParameter{
    var ncmb: NCMBObject  //  データ保存用
    //    必要が出たら追加してください。
    var name: String
    var userName: String
    var departments: String
    var kamoku: String
    var youbi: String
    var choice: String
    var grade: String
    var SchoolName: String
    var selection: String
    var introduction: String
    
    
    init(_ parameter: NCMBObject) {
        print("teacher parameter is creative")
//        空だった時の例外処理を行う関数
        func fillS(_ s: String?) -> String{
            if s == nil {
                return ""
            }
            else{
                return s!
            }
        }
        func fillD(_ d: Double?) -> Double{
            if d == nil {
                return 0.d
            }
            else{
                return d!
            }
        }
        func fillI(_ i: Int?) -> Int{
            if i == nil {
                return 0
            }
            else{
                return i!
            }
        }
        
        self.ncmb = parameter
//        データ取得部分のコード
        self.name = fillS(parameter.object(forKey: "name") as? String)
        self.userName = fillS(parameter.object(forKey: "userName") as? String)
        self.departments = fillS(parameter.object(forKey: "departments") as? String)
        self.kamoku = fillS(parameter.object(forKey: "kamoku") as? String)
        self.youbi = fillS(parameter.object(forKey: "youbi") as? String)
        self.choice = fillS(parameter.object(forKey: "choice") as? String)
        self.grade = fillS(parameter.object(forKey: "grade") as? String)
        self.SchoolName = fillS(parameter.object(forKey: "SchoolName") as? String)
        self.selection = fillS(parameter.object(forKey: "selection") as? String)
        self.introduction = fillS(parameter.object(forKey: "introduction") as? String)
    }
}

class StudentParameter{
    
    var ncmb: NCMBObject  //  データ保存用
//    必要が出たら追加してください。
    var choice: String
    var objectId: String
    var SchoolName: String
    var selection: String
    var grade: String
    var parentEmailAdress: String
    var introduction: String
    var youbi: String
    var reports: [Report] = []
    
    init(_ parameter: NCMBObject) {
        print("student parameter is creative")
//        空だった時の例外処理を行う関数
        func fillS(_ s: String?) -> String{
            if s == nil {
                return ""
            }
            else{
                return s!
            }
        }
        func fillD(_ d: Double?) -> Double{
            if d == nil {
                return 0.d
            }
            else{
                return d!
            }
        }
        func fillI(_ i: Int?) -> Int{
            if i == nil {
                return 0
            }
            else{
                return i!
            }
        }
        
        self.ncmb = parameter
//        データ取得部分のコード
        self.SchoolName = fillS(parameter.object(forKey: "SchoolName") as? String)
        self.selection = fillS(parameter.object(forKey: "selection") as? String)
        self.choice = fillS(parameter.object(forKey: "choice") as? String)
        self.grade = fillS(parameter.object(forKey: "grade") as? String)
        self.parentEmailAdress = fillS(parameter.object(forKey: "parentEmailAdress") as? String)
        self.introduction = fillS(parameter.object(forKey: "introduction") as? String)
        self.youbi = fillS(parameter.object(forKey: "youbi") as? String)
        self.objectId = fillS(parameter.object(forKey: "objectId") as? String)
        self.reports = fillS(parameter.object(forKey: "reports") as ? "")
    }
}
