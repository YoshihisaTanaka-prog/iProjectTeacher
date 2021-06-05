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
    var userName: String
    var furigana: String
    var mailAddress: String
    var grade: String
    var imageName: String?
    var oneOnOneSerch: String
    var teacherParameter: TeacherParameter?
    var studentParameter: StudentParameter?
    
    
    
    init(_ user: NCMBUser) {
        
        self.ncmb = user
        self.userName = user.object(forKey: "userName") as! String
        self.imageName = user.object(forKey: "imageName") as? String
        self.mailAddress = user.mailAddress
        self.userName = ""
        self.grade = ""
        self.furigana = ""
        
//        個人チャットを検索するためのパラメータ
        if (NCMBUser.current()?.objectId)! < self.ncmb.objectId {
            oneOnOneSerch = (NCMBUser.current()?.objectId)! + "-" + self.ncmb.objectId
        }
        else{
            oneOnOneSerch = self.ncmb.objectId + "-" + (NCMBUser.current()?.objectId)!
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
                        self.teacherParameter = TeacherParameter(param!, userName: &userName, furigana: &furigana, grade: &grade)
                    }
                    else{
                        self.studentParameter = StudentParameter(param!, userName: &userName, furigana: &furigana, grade: &grade)
                    }
                }
            }
        }
        
        //        画像の設定
        let imageName = user.object(forKey: "imageName") as? String
        //　負荷軽減のため、一回しかユーザーの画像はロードしないようにする。
        if( !userImagesCacheG.keys.contains(self.ncmb.objectId) ){
            if( imageName != nil ){
                print("Loading image")
                let file = NCMBFile.file(withName: imageName!, data: nil) as! NCMBFile
                file.getDataInBackground { (data, error) in
                    if error == nil {
                        if data != nil {
                            let image = UIImage(data: data!)
                            userImagesCacheG[self.ncmb.objectId] = image
                            print("Loaded image")
                        }
                    } else {
                        print(error!.localizedDescription)
                        self.setNoImage()
                    }
                }
            } else{
                setNoImage()
            }
        }
    }
    
    private func setNoImage(){
        if self.teacherParameter == nil{
            userImagesCacheG[self.ncmb.objectId] = UIImage(named: "studentNoImage.png")
        } else {
            userImagesCacheG[self.ncmb.objectId] = UIImage(named: "teacherNoImage.png")
        }
        print("no image")
    }
}

class TeacherParameter{
    var ncmb: NCMBObject  //  データ保存用
    //    必要が出たら追加してください。
    var departments: String
    var kamokuList: [[String]]
    var youbi: String
    var collage: String
    var selection: String
    var introduction: String
    
    
    init(_ parameter: NCMBObject, userName: inout String, furigana: inout String, grade: inout String) {
        
        self.ncmb = parameter
//        データ取得部分のコード
        self.departments = parameter.object(forKey: "departments") as? String ?? ""
        self.kamokuList = []
        self.youbi = parameter.object(forKey: "youbi") as? String ?? "FFFFFFF"
        self.collage = parameter.object(forKey: "collage") as? String ?? ""
        self.selection = parameter.object(forKey: "selection") as? String ?? ""
        self.introduction = parameter.object(forKey: "introduction") as? String ?? ""
        let subjectList = [
            ["modernWriting","ancientWiting","chineseWriting"],
            ["math1a","math2b","math3c"],
            ["physics","chemistry","biology","earthScience"],
            ["geography","japaneseHistory","worldHistory","modernSociety","ethics","politicalScienceAndEconomics"],
            ["hsEnglish"]
        ]
        for sList in subjectList{
            var kamoku: [String] = []
            for s in sList{
                let isAbleToTeach = parameter.object(forKey: "isAbleToTeach" + s.upHead) as? Bool ?? false
                if isAbleToTeach{
                    kamoku.append(s)
                }
            }
            kamokuList.append(kamoku)
        }
        
        userName = parameter.object(forKey: "userName") as? String ?? ""
        furigana = parameter.object(forKey: "furigana") as? String ?? ""
        grade = parameter.object(forKey: "grade") as? String ?? "0"
    }
}

class StudentParameter{
    
    var ncmb: NCMBObject  //  データ保存用
//    必要が出たら追加してください。
    var choice: [[String]]
    var schoolName: String
    var selection: String
    var parentEmailAdress: String
    var introduction: String
    var youbi: String
    
    init(_ parameter: NCMBObject, userName: inout String, furigana: inout String, grade: inout String) {
        
        self.ncmb = parameter
//        データ取得部分のコード
        self.schoolName = parameter.object(forKey: "schoolName") as? String ?? ""
        self.selection = parameter.object(forKey: "selection") as? String ?? ""
        self.choice = parameter.object(forKey: "choice") as? [[String]] ?? []
        self.parentEmailAdress = parameter.object(forKey: "parentEmailAdress") as? String ?? ""
        self.introduction = parameter.object(forKey: "introduction") as? String ?? ""
        self.youbi = parameter.object(forKey: "youbi") as? String ?? "FFFFFFF"
        
        userName = parameter.object(forKey: "userName") as? String ?? ""
        furigana = parameter.object(forKey: "furigana") as? String ?? ""
        grade = parameter.object(forKey: "grade") as? String ?? "0"

    }
}

