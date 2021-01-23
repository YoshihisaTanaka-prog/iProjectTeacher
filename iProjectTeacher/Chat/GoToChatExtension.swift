//
//  GoToChatExtension.swift
//  ChatTest
//
//  Created by 田中義久 on 2021/01/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit
import NCMB

extension UIViewController {
    
    func goToChat(){
        let storyboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
        let rootNavigationController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
        let rootViewController = rootNavigationController.topViewController as!ChatTableViewController
        rootViewController.selectedChatRoom = nil
        rootViewController.view.backgroundColor = UIColor.white
        self.present(rootNavigationController, animated: true, completion: nil)
    }
    
    func goToChat(chatGroupId: String, _ isGroup: Bool){
        if(isGroup){
            let query = NCMBQuery(className: "ChatGroup")
            query?.whereKey("objectId", equalTo: chatGroupId)
            query?.findObjectsInBackground({ (result, error) in
                if(error == nil){
                    if(result!.count == 0){
                        self.showOkAlert(title: "Error", message: "チャットルームを見つけることができませんでした。")
                    }
                    else{
                        let object = result!.first! as! NCMBObject
                        let storyboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                        let rootNavigationController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
                        let rootViewController = rootNavigationController.topViewController as!ChatTableViewController
                        rootViewController.selectedChatRoom = ChatRoom(object,isGroup)
                        rootViewController.view.backgroundColor = UIColor.white
                        self.present(rootNavigationController, animated: true, completion: nil)
                    }
                }
                else{
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
        }
        else{
            let query = NCMBQuery(className: "OneOnOneChat")
            query?.whereKey("objectId", equalTo: chatGroupId)
            query?.findObjectsInBackground({ (result, error) in
                if(error == nil){
                    if(result!.count == 0){
                        self.showOkAlert(title: "Error", message: "チャットルームを見つけることができませんでした。")
                    }
                    else{
                        let object = result!.first! as! NCMBObject
                        let storyboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                        let rootNavigationController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
                        let rootViewController = rootNavigationController.topViewController as!ChatTableViewController
                        rootViewController.selectedChatRoom = ChatRoom(object,isGroup)
                        rootViewController.view.backgroundColor = UIColor.white
                        self.present(rootNavigationController, animated: true, completion: nil)
                    }
                }
                else{
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
        }
    }
    
    func goToChat(userId: String){
        
        var userIds:String!
        if (NCMBUser.current()?.objectId)! < userId {
            userIds = (NCMBUser.current()?.objectId)! + "-" + userId
        }
        else{
            userIds = userId + "-" + (NCMBUser.current()?.objectId)!
        }
        
        let query = NCMBQuery(className: "OneOnOneChat")
        query?.whereKey("userIds", equalTo: userIds)
        query?.findObjectsInBackground({ (result, error) in
        // 読み込みが成功したら、
            if(error == nil){
                if(result!.count == 0){
                    //チャットルームが存在しない時に新規作成
                    
                    //チャットルームの作成
                    let object = NCMBObject(className: "OneOnOneChat")
                    object?.setObject(userIds, forKey: "userIds")
                    object?.saveInBackground({ (error) in
                        if(error != nil){
                            // エラーが発生したら、
                            self.showOkAlert(title: "Error", message: error!.localizedDescription)
                        }
                        else{
                            let storyboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                            let rootNavigationController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
                            let rootViewController = rootNavigationController.topViewController as!ChatTableViewController
                            rootViewController.selectedChatRoom = ChatRoom(object!,false)
                            rootViewController.view.backgroundColor = UIColor.white
                            self.present(rootNavigationController, animated: true, completion: nil)
                            
//                            チャットルームに参加するユーザの登録
                            let object1 = NCMBObject(className: "UserChatGroup")
                            object1?.setObject(object!.objectId, forKey: "chatGroupId")
                            object1?.setObject(object!, forKey: "chatGroup")
                            object1?.setObject(false, forKey: "isGroup")
                            object1?.setObject(true, forKey: "isPermited")
                            object1?.setObject(NCMBUser.current(), forKey: "user")
                            object1?.saveInBackground({ (erroe) in
                                if(error != nil){
                                    // エラーが発生したら、
                                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                }
                            })
                            let userQuery = NCMBUser.query()
                            userQuery?.whereKey("objectId", equalTo: userId)
                            userQuery?.whereKey("isActive", notEqualTo: false)
                            userQuery?.findObjectsInBackground({ (resuluts, error) in
                                if(error == nil){
                                    if(resuluts!.count != 0){
                                        let opponents = resuluts as! [NCMBUser]
                                        let user = opponents.first!
                                        let object2 = NCMBObject(className: "UserChatGroup")
                                        object2?.setObject(object!.objectId, forKey: "chatGroupId")
                                        object2?.setObject(object!, forKey: "chatGroup")
                                        object2?.setObject(false, forKey: "isGroup")
                                        object2?.setObject(false, forKey: "isPermited")
                                        object2?.setObject(user, forKey: "user")
                                        object2?.saveInBackground({ (erroe) in
                                            if(error != nil){
                                                // エラーが発生したら、
                                                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                                fatalError()
                                            }
                                        })
                                    }
                                    else{
                                        print("User is not exist!")
                                        fatalError()
                                    }
                                }
                                else{
                                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                }
                            })
                        }
                    })
                }
                else{
                    let chatRoom = result!.first as! NCMBObject
                    
                    let storyboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                    let rootNavigationController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
                    let rootViewController = rootNavigationController.topViewController as!ChatTableViewController
                    rootViewController.selectedChatRoom = ChatRoom(chatRoom,false)
                    rootViewController.view.backgroundColor = UIColor.white
                    self.present(rootNavigationController, animated: true, completion: nil)
                }
            }
            else{
                // エラーが発生したら、
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
    
}
