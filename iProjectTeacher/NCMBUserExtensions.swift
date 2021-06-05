//
//  Extensions.swift
//  ChatTest
//
//  Created by 田中義久 on 2021/01/13.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

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

