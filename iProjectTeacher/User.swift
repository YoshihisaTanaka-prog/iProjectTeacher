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
    var userName: String
    var isTeacher: Bool
    var oneOnOneSerch: String
    var teacherParameter: TeacherParameter?
    var studentParameter: StudentParameter?
    
    
    init(_ user: NCMBUser) {
        
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
        let parameter = user.object(forKey: "parameter") as! NCMBObject
        if(self.isTeacher){
            self.teacherParameter = TeacherParameter(parameter)
        }
        else{
            if parameter == nil {
                fatalError("parameter is nil!")
            }
            self.studentParameter = StudentParameter(parameter)
        }
        
//        画像の設定
        let imageUrl = user.object(forKey: "imageURL") as? String
        if( imageUrl != nil ){
            let file = NCMBFile.file(withName: imageUrl!, data: nil) as! NCMBFile
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
//    記入例
    var departments: String
    init(_ parameter: NCMBObject) {
        self.departments = parameter.object(forKey: "departments") as! String
    }
}

class StudentParameter{
    var SchoolName: String
    var selection: String
    
    init(_ parameter: NCMBObject) {
        let school = parameter.object(forKey: "SchoolName") as? String
        self.SchoolName = school!
        self.selection = parameter.object(forKey: "selection") as! String
    }
}
