//
//  ChatRoom.swift
//  ChatTest4
//
//  Created by 田中義久 on 2021/08/21.
//

import Foundation
import NCMB

protocol ChatRoomDelegate {
    func didFinishLoadChats(chats: [Chat])
    func showOkAlertCR(title: String, message: String)
}

class ChatRoom{
    var delegate: ChatRoomDelegate?
    
    var id: String
    var userInfo: [[String]]
    var roomName: String
    var lastTimeMessageSent: Date
    var isGroup = true
    var imageId: String
    
    init(){
        id = "user-" + currentUserG.userId
        userInfo = []
        roomName = "サポートセンター"
        lastTimeMessageSent = Date()
        isGroup = false
        imageId = "sapo-to"
    }
    
    init(chatRoom: NCMBObject, _ vc: UIViewController){
//        情報の読み込み
        id = chatRoom.objectId
        lastTimeMessageSent = chatRoom.object(forKey: "lastTimeMessageSent") as! Date
        var userInfo = chatRoom.object(forKey: "userInfo") as! [[String]]
        self.userInfo = userInfo
        imageId = "chat-" + chatRoom.objectId
        var name = "No name"
        let roomName = chatRoom.object(forKey: "roomName") as? String
        if roomName == nil{
            isGroup = false
            for ui in userInfo{
                if ui[0] != currentUserG.userId{
                    name = ui[1]
                    imageId = ui[0]
                }
            }
        }
        self.roomName = roomName ?? name
        
//        情報の上書き
        func numOfWrongCurrentUserInfoIndex() -> Int?{
            for i in 0..<userInfo.count{
                let ui = userInfo[i]
                if ui[0] == currentUserG.userId{
                    if(ui[1] == currentUserG.userName){
                        return nil
                    } else {
                        return i
                    }
                }
            }
            return nil
        }
        if let index = numOfWrongCurrentUserInfoIndex(){
            userInfo.remove(at: index)
            userInfo.append([currentUserG.userId, currentUserG.userName])
            let o = chatRoom
            o.setObject(userInfo, forKey: "userInfo")
            o.saveInBackground { error in
                if error != nil{
                    vc.showOkAlert(title: "Loading chats error", message: error!.localizedDescription)
                }
            }
        }
    }
    
    convenience init(user: User){
        
        let o = NCMBObject(className: "ChatRoom", objectId: user.chatRoomId)!
        var error: NSError? = nil
        o.fetch(&error)
        self.init(chatRoom: o, UIViewController())
    }
    
    func loadChats(){
        let query = NCMBQuery(className: "Chat")
        query?.order(byDescending: "createDate")
        query?.whereKey("chatRoomId", equalTo: self.id)
        if let joinedTime = cachedJoinedTimeG[self.id] {
            query?.whereKey("createDate", greaterThan: joinedTime)
        }
        query?.findObjectsInBackground({ result, error in
            if error == nil{
                let obs = result as? [NCMBObject] ?? []
                var loadedChats = [Chat]()
                for o in obs{
                    loadedChats.insert(.init(chat: o), at: 0)
                }
                self.delegate?.didFinishLoadChats(chats: loadedChats)
            } else{
                self.delegate?.showOkAlertCR(title: "Loading chats error", message: error!.localizedDescription)
            }
        })
    }
    
    func searchUserName(userId: String) -> String{
        for ui in userInfo{
            if ui[0] == userId{
                return ui[1]
            }
        }
        return "No name"
    }
    
    public var isFirst: Bool{
        if self.id.ary.contains("-"){
            return false
        }
        let q = NCMBQuery(className: "UserChatRoom")
        q?.whereKey("userId", equalTo: currentUserG.userId)
        q?.whereKey("chatRoomId", equalTo: self.id)
        if let result = try? q?.findObjects(){
            if let o = result.first as? NCMBObject{
                return o.object(forKey: "isFirst") as? Bool ?? true
            } else{
                return true
            }
        } else {
            return true
        }
        
    }
}
