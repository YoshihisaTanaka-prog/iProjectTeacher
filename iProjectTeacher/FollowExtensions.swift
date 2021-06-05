//
//  Extensions.swift
//  ChatTest
//
//  Created by 田中義久 on 2021/01/13.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB



extension UIViewController{
    
    func loadFollowList(){
        if NCMBUser.current() != nil{
            let query = NCMBQuery(className: "Follow")
            query?.includeKey("fromUser")
            query?.includeKey("toUser")
            query?.whereKey("fromUser", equalTo: NCMBUser.current()!)
            query?.findObjectsInBackground({ (result, error) in
                if(error == nil){
                    for follow in result as! [NCMBObject]{
                        let user = follow.object(forKey: "toUser") as! NCMBUser
                        let status = follow.object(forKey: "status") as! Int
                        if(status < 0){
                            blockUserListG.append(User(user))
                        }
                        else{
                            followUserListG.append(User(user))
                        }
                    }
                }
            })
        }
    }
    
    func createFollow(_ ncmbUser: NCMBUser){
        
        let query = NCMBQuery(className: "Follow")
        query?.whereKey("fromUser", equalTo: NCMBUser.current()!)
        query?.whereKey("toUser", equalTo: ncmbUser)
        query?.findObjectsInBackground({ result, error in
            if error == nil {
                if result!.count == 0 {
                    let object1 = NCMBObject(className: "Follow")
                    object1?.setObject(NCMBUser.current()!, forKey: "fromUser")
                    object1?.setObject(ncmbUser, forKey: "toUser")
                    object1?.setObject(1, forKey: "status")
                    object1?.saveInBackground({ error in
                        if error == nil {
                            let object2 = NCMBObject(className: "Follow")
                            object2?.setObject(NCMBUser.current()!, forKey: "toUser")
                            object2?.setObject(ncmbUser, forKey: "fromUser")
                            object2?.setObject(0, forKey: "status")
                            object2?.saveInBackground({ error in
                                if error == nil{
                                    followUserListG.append(User(ncmbUser))
                                } else {
                                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                }
                            })
                        } else{
                            self.showOkAlert(title: "Error", message: error!.localizedDescription)
                        }
                    })
                } else {
                    return
                }
            } else {
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
}
