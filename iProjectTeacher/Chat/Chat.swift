//
//  Chat.swift
//  iProject
//
//  Created by 田中義久 on 2021/01/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit
import NCMB

class Chat {
    var message: String
    var userId: String
    var userName: String
    var isFromMe: Bool
    var isGroup: Bool
    var numOfRead: Int
    var sentTime: String
    
    init(_ chat: NCMBObject) {
        self.message = chat.object(forKey: "message") as! String
        self.isGroup = chat.object(forKey: "isGroup") as! Bool
        
        let chatUser = chat.object(forKey: "user") as! NCMBUser
        self.userId = chatUser.objectId
        self.userName = chatUser.userName
        
        //        送信か受信か
        if( self.userId == NCMBUser.current()?.objectId ){
            self.isFromMe = true
        }
        else{
            self.isFromMe = false
        }
        
        //        送信された時間
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        self.sentTime = f.string(from: chat.createDate)
        
        //        既読
        self.numOfRead = 0
        let query = NCMBQuery(className: "ChatRead")
        query?.whereKey("chatId", equalTo: chat.objectId)
        query?.findObjectsInBackground({ (result, error) in
            if(error != nil){
                // エラーが発生したら、
                print("error")
            }
            else{
                // 読み込みが成功したら、
                if(result != nil){
                    self.numOfRead = result!.count
                }
            }
        })
    }
}

class ChatList {
    var chats: [[Chat]] = []
    var dates: [String] = []
    
    
    func makeChats(_ chatList: [NCMBObject]){
        self.chats = []
        self.dates = []
        if( chatList.count != 0 ){
            //            日付ごとに分離するためのformatter
            let f = DateFormatter()
            f.timeStyle = .none
            f.dateStyle = .long
            f.locale = Locale(identifier: "ja_JP")
            
            //            日付比較用
            var sentDate:String = ""
            for j in 1...chatList.count {
                let i = chatList.count - j
                //                チャットが送られた日付が変わったら日付を挟み、比較用の日付を更新
                if( sentDate != f.string(from: chatList[i].createDate) ){
                    sentDate = f.string(from: chatList[i].createDate)
                    self.dates.insert(sentDate, at: 0)
                    self.chats.insert([], at: 0)
                }
                //                チャットを追加
                self.chats[0].insert(Chat(chatList[i]), at: 0)
                
                //                既読したというデータを追加
                let checkUser = chatList[i].object(forKey: "user") as! NCMBUser
                if(checkUser.objectId != NCMBUser.current()?.objectId){
                    let query = NCMBQuery(className: "ChatRead")
                    query?.whereKey("chatId", equalTo: chatList[i].objectId)
                    query?.whereKey("userId", equalTo: NCMBUser.current()!.objectId)
                    query?.findObjectsInBackground({ (result, error) in
                        if(error != nil){
                            // エラーが発生したら、
                            print(error!.localizedDescription)
                            fatalError()
                        }
                        else{
                            // 読み込みが成功したら、
                            if(result?.count == 0){
                                let object = NCMBObject(className: "ChatRead")
                                object?.setObject(chatList[i].objectId, forKey: "chatId")
                                object?.setObject(NCMBUser.current()!.objectId, forKey: "userId")
                                object?.saveInBackground({ (error) in
                                    if(error != nil){
                                        // エラーが発生したら、
                                        print(error!.localizedDescription)
                                        fatalError()
                                    }
                                })
                            }
                        }
                    })
                }
            }
        }
    }
    
}

class ChatRoom{
    var objectId: String
    var isGroup: Bool
    var isPermited: Bool
    var name: String
    var lastSentDate: Date
    var userImages: Dictionary<String, UIImage?> = [:]
    
    //    自分が参加しているチャットルームから検索する場合
    init(_ chatRoom: NCMBObject, _ isGroup: Bool){
        
        self.objectId = chatRoom.objectId
        self.isGroup = isGroup
        self.lastSentDate = Date()
        self.lastSentDate = chatRoom.object(forKey: "lastSentDate") as! Date
        self.name = ""
//        self.userImages.updateValue(nil, forKey: NCMBUser.current()!.objectId)
        if(isGroup){
            self.name = chatRoom.object(forKey: "name") as! String
        }
        self.isPermited = false
        let query = NCMBQuery(className: "UserChatGroup")
        query?.includeKey("user")
        query?.whereKey("user", notEqualTo: NCMBUser.current())
        query?.whereKey("chatGroupId", equalTo: chatRoom.objectId)
        query?.whereKey("isGroup", equalTo: isGroup)
        query?.findObjectsInBackground({ (result, error) in
            if(error != nil){
                // エラーが発生したら、
                print(error!.localizedDescription)
            }
            else{
                // 読み込みが成功したら、
                let messages = result as! [NCMBObject]
                if( messages.count != 0 ){
                    if(isGroup){
                        self.isPermited = messages.first!.object(forKey: "isPermited") as! Bool
                    }
                    else{
                        let user = messages.first!.object(forKey: "user") as! NCMBUser
                        self.name = user.userName
                        self.isPermited = messages.first!.object(forKey: "isPermited") as! Bool
                    }
                }
            }
            })
    }
    
    //    相手のユーザーから検索する場合
    init(_ user: User) {
        self.isGroup = false
        self.isPermited = false
        self.name = user.userName
        self.objectId = ""
        self.lastSentDate = Date()
        let query = NCMBQuery(className: "OneOnOneChat")
        query?.whereKey("userIds", equalTo: user.oneOnOneSerch)
        query?.findObjectsInBackground({ (result, error) in
            if(error != nil){
                // エラーが発生したら、
                print("error")
            }
            else{
                // 読み込みが成功したら、
                let messages = result as! [NCMBObject]
                //                部屋がある時
                if( messages.count != 0 ){
                    self.objectId = messages.first!.objectId
                    self.lastSentDate = messages.first!.object(forKey: "lastSentDate") as! Date
                    let ugQuery = NCMBQuery(className: "UserChatGroup")
                    ugQuery?.includeKey("user")
                    ugQuery?.whereKey("user", equalTo: NCMBUser.current()!)
                    ugQuery?.whereKey("chatGroupId", equalTo: self.objectId)
                    ugQuery?.whereKey("isGroup", equalTo: false)
                    ugQuery?.findObjectsInBackground({ (result, error) in
                        if(error == nil){
                            let ugObject = result!.first as! NCMBObject
                            self.isPermited = ugObject.object(forKey: "isPermited") as! Bool
                        }
                        else{
                            print(error!.localizedDescription)
                            fatalError()
                        }
                    })
                }
                    //                    部屋がない時部屋を作る
                else{
                    self.isPermited = true
                    let userQuery = NCMBUser.query()
                    userQuery?.whereKey("isActive", notEqualTo: false)
                    userQuery?.whereKey("objectId", equalTo: user.userId)
                    userQuery?.findObjectsInBackground({ (result2, error2) in
                        if(error2 == nil){
                            if(result2!.count == 0){
                                print("This user is not exist!")
                                fatalError()
                            }
                            else{
                                let opUser = result2!.first as! NCMBUser
                                //チャットルームの作成
                                var userIds: String!
                                if (NCMBUser.current()?.objectId)! < user.userId {
                                    userIds = (NCMBUser.current()?.objectId)! + "-" + user.userId
                                }
                                else{
                                    userIds = user.userId + "-" + (NCMBUser.current()?.objectId)!
                                }
                                let object = NCMBObject(className: "OneOnOneChat")
                                object?.setObject(userIds, forKey: "userIds")
                                object?.saveInBackground({ (error) in
                                    if(error != nil){
                                        // エラーが発生したら、
                                        print(error!.localizedDescription)
                                    }
                                    else{
                                        self.objectId = object!.objectId
//                                        チャットルームに参加するユーザの登録
                                        let object1 = NCMBObject(className: "UserChatGroup")
                                        object1?.setObject(object!.objectId, forKey: "chatGroupId")
                                        object1?.setObject(object!, forKey: "chatGroup")
                                        object1?.setObject(false, forKey: "isGroup")
                                        object1?.setObject(true, forKey: "isPermited")
                                        object1?.setObject(self.lastSentDate, forKey: "lastSentDate")
                                        object1?.setObject(NCMBUser.current(), forKey: "user")
                                        object1?.saveInBackground({ (erroe) in
                                            if(error != nil){
                                                // エラーが発生したら、
                                                print(error!.localizedDescription)
                                            }
                                        })
                                        let object2 = NCMBObject(className: "UserChatGroup")
                                        object2?.setObject(object!.objectId, forKey: "chatGroupId")
                                        object2?.setObject(object!, forKey: "chatGroup")
                                        object2?.setObject(false, forKey: "isGroup")
                                        object2?.setObject(false, forKey: "isPermited")
                                        object2?.setObject(opUser, forKey: "user")
                                        object2?.saveInBackground({ (erroe) in
                                            if(error != nil){
                                                // エラーが発生したら、
                                                print(error!.localizedDescription)
                                                fatalError()
                                            }
                                        })
                                    }
                                })
                            }
                        }
                    })
                }
            }
        })
    }
    
    func mix(_ rooms1: [ChatRoom], _ rooms2: [ChatRoom] ) -> [ChatRoom]{
        return []
    }
}
