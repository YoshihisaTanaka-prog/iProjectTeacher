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
    var isTeacher: Bool
    var oneOnOneSerch: String
    var teacherParameter: TeacherParameter?
    var studentParameter: StudentParameter?
    
    
    init(_ user: NCMBUser) {
        
        self.ncmb = user
        self.userId = user.objectId
        self.userName = user.object(forKey: "userName") as! String
        self.isTeacher = user.object(forKey: "isTeacher") as! Bool
        
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
                if(param!.ncmbClassName == "teacherParameter"){
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
    var departments: String
    
    init(_ parameter: NCMBObject) {
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
        self.departments = fillS(parameter.object(forKey: "departments") as? String)
    }
}

class StudentParameter{
    var ncmb: NCMBObject  //  データ保存用
//    必要が出たら追加してください。
    var SchoolName: String
    var selection: String
    
    init(_ parameter: NCMBObject) {
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
    }
}
