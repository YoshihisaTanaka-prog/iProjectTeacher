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
    var userId: String
    var userName = ""
    var furigana = ""
    var mailAddress = ""
    var grade = "0"
    var oneOnOneSerch: String
    var selection = ""
    var introduction = ""
    var youbiTimeList: [[String]] = []
    var teacherParameter: TeacherParameter?
    var studentParameter: StudentParameter?
    
    init(_ userId: String, _ vc: UIViewController){
        self.userId = userId
        
//        個人チャットを検索するためのパラメータ
        if (NCMBUser.current()?.objectId)! < self.userId {
            oneOnOneSerch = (NCMBUser.current()?.objectId)! + "-" + self.userId
        }
        else{
            oneOnOneSerch = self.userId + "-" + (NCMBUser.current()?.objectId)!
        }
        
//        ユーザの詳細データ
        let query1 = NCMBQuery(className: "StudentParameter")!
        query1.whereKey("userId", equalTo: self.userId)
        let query2 = NCMBQuery(className: "TeacherParameter")!
        query2.whereKey("userId", equalTo: self.userId)
        let query = NCMBQuery.orQuery(withSubqueries: [query1,query2])
        query?.findObjectsInBackground({ result, error in
            if error == nil{
                let param = result!.first! as! NCMBObject
                if param.ncmbClassName == "TeacherParameter" {
                    self.teacherParameter = TeacherParameter(param, userId: self.userId, userName: &self.userName, furigana: &self.furigana, grade: &self.grade, selection: &self.selection, introduction: &self.introduction, youbiTimeList: &self.youbiTimeList)
                } else {
                    self.studentParameter = StudentParameter(param, userId: self.userId, userName: &self.userName, furigana: &self.furigana, grade: &self.grade, selection: &self.selection, introduction: &self.introduction, youbiTimeList: &self.youbiTimeList)
                }
            } else {
                vc.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
    
    convenience init(_ user: NCMBUser) {
        self.init(user.objectId, UIViewController())
    }
}

class Parameter{
    var ncmb: NCMBObject
    init(_ parameter: NCMBObject){
        self.ncmb = parameter
        
        let imageName = parameter.object(forKey: "imageName") as? String
        let userId = parameter.object(forKey: "userId") as! String
        
        
//        if userImagesCacheG[userId] == nil{
//            if imageName == nil {
//                setNoImage(userId)
//            } else {
//                let file =  NCMBFile.file(withName: userId,data:nil) as! NCMBFile
//                file.getDataInBackground { (data, error) in
//                    if error == nil {
//                        if data == nil {
//                            self.setNoImage(userId)
//                        } else {
//                            let image = UIImage(data: data!)
//                            userImagesCacheG[userId] = image
//                        }
//                    } else {
//                        self.setNoImage(userId)
//                    }
//                }
//            }
//        }
    }
    
    private func setNoImage(_ userId: String){
        if self.ncmb.ncmbClassName == "TeacherParameter" {
            userImagesCacheG[userId] = UIImage(named: "teacherNoImage.png")
        } else {
            userImagesCacheG[userId] = UIImage(named: "studentNoImage.png")
        }
    }
}

class TeacherParameter: Parameter{
    //    必要が出たら追加してください。
    var departments: String
    var kamokuList: [[String]]
    var collage: String
    
    override init(_ parameter: NCMBObject) {
//        データ取得部分のコード
        print("teacher")
        self.departments = parameter.object(forKey: "departments") as? String ?? ""
        self.collage = parameter.object(forKey: "collage") as? String ?? ""
        self.kamokuList = []
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
        super.init(parameter)
    }
    
    
    convenience init(_ parameter: NCMBObject, userId: String, userName: inout String, furigana: inout String, grade: inout String, selection: inout String, introduction: inout String, youbiTimeList: inout [[String]]) {
        
        self.init(parameter)
        
        userName = parameter.object(forKey: "userName") as? String ?? ""
        furigana = parameter.object(forKey: "furigana") as? String ?? ""
        grade = parameter.object(forKey: "grade") as? String ?? "0"
        selection = parameter.object(forKey: "selection") as? String ?? ""
        introduction = parameter.object(forKey: "introduction") as? String ?? ""
        
        let youbiList = ["Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        for y in youbiList{
            let youbi = parameter.object(forKey: y + "Time") as? [String] ?? []
            
            youbiTimeList.append(youbi)
        }
        
        let imageName = parameter.object(forKey: "imageName") as? String
        if userImagesCacheG[userId] == nil && imageName != nil {
            let file =  NCMBFile.file(withName: userId,data:nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    userImagesCacheG[userId] = image
                } else {
                    userImagesCacheG[userId] = UIImage(named: "teacherNoImage.png")
                }
            }
        }
    }
}

class StudentParameter: Parameter{
//    必要が出たら追加してください。
    var choice: [[String]]
    var schoolName: String
    var parentEmailAdress: String
    
    override init(_ parameter: NCMBObject) {
        print("student")
        self.schoolName = parameter.object(forKey: "schoolName") as? String ?? ""
        self.choice = parameter.object(forKey: "choice") as? [[String]] ?? []
        self.parentEmailAdress = parameter.object(forKey: "parentEmailAdress") as? String ?? ""
        
        super.init(parameter)
    }
    
    convenience init(_ parameter: NCMBObject, userId: String, userName: inout String, furigana: inout String, grade: inout String, selection: inout String, introduction: inout String, youbiTimeList: inout [[String]]) {
        self.init(parameter)
//        データ取得部分のコード
        
        userName = parameter.object(forKey: "userName") as? String ?? ""
        furigana = parameter.object(forKey: "furigana") as? String ?? ""
        grade = parameter.object(forKey: "grade") as? String ?? "0"
        selection = parameter.object(forKey: "selection") as? String ?? ""
        introduction = parameter.object(forKey: "introduction") as? String ?? ""
        
        let youbiList = ["Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        for y in youbiList{
            let youbi = parameter.object(forKey: y + "Time") as? [String] ?? []
            
            youbiTimeList.append(youbi)
        }
    }
}

