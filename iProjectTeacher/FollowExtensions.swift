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
            //query?.includeKey("fromUserId")
            //query?.includeKey("toUserId")
            query?.whereKey("fromUserId", equalTo: NCMBUser.current()!.objectId)
            query?.findObjectsInBackground({ (result, error) in
                if(error == nil){
                    blockedUserIdListG = []
                    waitingUserListG = []
                    followUserListG = []
                    favoriteUserListG = []
                    for follow in result as! [NCMBObject]{
                        let userId = follow.object(forKey: "toUserId") as! String
                        let status = follow.object(forKey: "status") as! Int
                        if(status < 0){
                            blockedUserIdListG.append(userId)
                        }
                        else{
                            let u = User(userId: userId, isNeedParameter: true, viewController: self)
                            u.status = status
                            switch status {
                            case 0:
                                waitingUserListG.append(u)
                            case 1:
                                followUserListG.append(u)
                            case 2:
                                favoriteUserListG.append(u)
                            default:
                                break
                            }
                        }
                    }
                } else{
                    print(error!.localizedDescription)
                }
                
            })
        }
    }
    
    func mixFollowList() -> [User]{
        var ret = waitingUserListG
        for f in favoriteUserListG{
            ret.append(f)
        }
        for f in followUserListG{
            ret.append(f)
        }
        return ret
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
