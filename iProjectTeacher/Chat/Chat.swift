//
//  Chat.swift
//  ChatTest4
//
//  Created by 田中義久 on 2021/08/21.
//

import Foundation
import NCMB

protocol ChatDelegate {
    func didFinishSendingMessage()
    func showOkAlertC(title: String, message: String)
}

class Chat{
    
    var delegate: ChatDelegate?
    
    var id: String
    var chatRoomId: String
    var sentUserId: String
    var message: String
    var sentTime: Date
    var numOfReadUser: Int
    
    init(){
        id = ""
        chatRoomId = ""
        sentUserId = ""
        message = ""
        sentTime = Date()
        numOfReadUser = 0
    }
    
    init(chat: NCMBObject){
        id = chat.objectId
        chatRoomId = chat.object(forKey: "chatRoomId") as! String
        let sentUserId = chat.object(forKey: "sentUserId") as! String
        self.sentUserId = sentUserId
        message = chat.object(forKey: "message") as! String
        sentTime = chat.createDate
        var readUserIds = chat.object(forKey: "readUserIds") as! [String]
        if !(readUserIds.contains(currentUserG.userId)) && currentUserG.userId != sentUserId {
            readUserIds.append(currentUserG.userId)
            let o = chat
            o.setObject(readUserIds, forKey: "readUserIds")
            o.saveInBackground { error in
            }
        }
        numOfReadUser = readUserIds.count
    }
    
    func sendMessage(message: String, chatRoomId: String){
        let object = NCMBObject(className: "Chat")
        object?.setObject(message, forKey: "message")
        object?.setObject(chatRoomId, forKey: "chatRoomId")
        object?.setObject(currentUserG.userId, forKey: "sentUserId")
        object?.setObject([], forKey: "readUserIds")
        object?.saveInBackground({ error in
            if error == nil{
                if !chatRoomId.ary.contains("-"){
                    let o = NCMBObject(className: "ChatRoom", objectId: chatRoomId)
                    o?.setObject(Date(), forKey: "lastTimeMessageSent")
                    o?.saveInBackground({ error in
                        if error == nil{
                            self.delegate?.didFinishSendingMessage()
                        } else{
                            self.delegate?.showOkAlertC(title: "Saving message sent time error", message: error!.localizedDescription)
                        }
                    })
                } else {
                    self.delegate?.didFinishSendingMessage()
                }
            } else{
                self.delegate?.showOkAlertC(title: "Sending message error", message: error!.localizedDescription)
            }
        })
    }
    
}
