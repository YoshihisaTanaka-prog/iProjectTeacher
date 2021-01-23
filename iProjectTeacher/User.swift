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

// userImages[userのobjectId]で画像を取り出せるようにした。
var userImages: Dictionary<String, UIImage?> = [:]

class User {
    var userId: String
    var userName: String
//    var userRole: String
    var oneOnOneSerch: String
    
    init(_ user: NCMBUser) {
        
        self.userId = user.objectId
        self.userName = user.object(forKey: "userName") as! String
//        self.userRole = user.object(forKey: "userRole") as! String
        
//        個人チャットを検索するためのパラメータ
        if (NCMBUser.current()?.objectId)! < self.userId {
            oneOnOneSerch = (NCMBUser.current()?.objectId)! + "-" + self.userId
        }
        else{
            oneOnOneSerch = self.userId + "-" + (NCMBUser.current()?.objectId)!
        }
        
//        画像の設定
        userImages.updateValue(nil, forKey: user.objectId)
        let imageUrl = user.object(forKey: "imageURL") as? String
        if( imageUrl != nil ){
            let file = NCMBFile.file(withName: imageUrl!, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil {
                }
                else {
                    if data != nil {
                        let image = UIImage(data: data!)
                        userImages.updateValue(image, forKey: user.objectId)
                    }
                }
            }
        }
    }
}
