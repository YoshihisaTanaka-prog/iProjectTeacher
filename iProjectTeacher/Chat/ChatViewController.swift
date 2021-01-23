//
//  ChatViewController.swift
//  ChatTest
//
//  Created by 田中義久 on 2021/01/12.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class ChatViewController: UIViewController{
    
    var selectedChatRoom: ChatRoom!
    var chats = ChatList()
    var timer: Timer!
    var addBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedChatRoom.isGroup){
            addBarButtonItem = UIBarButtonItem(title: "メンバーの追加", style: .done, target: self, action: #selector(addBarButtonTapped(_:)))
            self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        }
        if(!selectedChatRoom.isPermited){
            let alertController = UIAlertController(title: "注意", message: "未参加のチャットルームです。このチャットルームに参加しますか？", preferredStyle: .alert)
            let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // OKボタンを押した後のアクション
                alertController.dismiss(animated: true, completion: nil)
                let query = NCMBQuery(className: "UserChatGroup")
                query?.whereKey("user", equalTo: NCMBUser.current()!)
                query?.whereKey("isGroup", equalTo: self.selectedChatRoom.isGroup)
                query?.whereKey("chatGroupId", equalTo: self.selectedChatRoom.objectId)
                query?.findObjectsInBackground({ (result, error) in
                    if(error == nil){
                        if(result!.count == 0){
                            self.showOkAlert(title: "Error", message: "Could not update!")
                        }
                        else{
                            let object = result!.first! as! NCMBObject
                            object.setObject(true, forKey: "isPermited")
                            object.saveInBackground { (error) in
                                if(error != nil){
                                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                                }
                            }
                        }
                    }
                    else{
                        self.showOkAlert(title: "Error", message: error!.localizedDescription)
                    }
                })
            }
            let alertCancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
                // OKボタンを押した後のアクション
                alertController.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertOkAction)
            alertController.addAction(alertCancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.dataSource = self
        tableView.delegate = self
        textView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadChat()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ChatViewController.update), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = selectedChatRoom.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //    override var inputAccessoryView: UIView? {
    //        return bottomView //通常はテキストフィールドのプロパティに設定しますが、画面を表示している間は常に表示したいため、ViewControllerのプロパティに設定します
    //    }
    @IBAction func tappedBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSend(){
        if( textView.text != "" ){
//            メッセージの送信
            let object = NCMBObject(className: "Chat")
            object?.setObject(selectedChatRoom.objectId, forKey: "chatGroupId")
            object?.setObject(selectedChatRoom.isGroup, forKey: "isGroup")
            object?.setObject(textView.text, forKey: "message")
            object?.setObject(NCMBUser.current()!, forKey: "user")
            textView.text = ""
            object?.saveInBackground({ (error) in
                if(error != nil){
                    // エラーが発生したら、
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
                else{
                    // 保存が成功したら、
                    let f = DateFormatter()
                    f.timeStyle = .none
                    f.dateStyle = .long
                    f.locale = Locale(identifier: "ja_JP")
                    if(self.chats.chats.last == nil || self.chats.dates.last! != f.string(from: Date())){
                        self.chats.chats.append([Chat(object!)])
                        self.chats.dates.append(f.string(from: Date()))
                    }
                    else{
                        self.chats.chats[self.chats.chats.count - 1].append(Chat(object!))
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.tableView.reloadData()
                        DispatchQueue.main.async {
                            if(self.chats.chats.last != nil){
                                let indexPath = IndexPath(row: self.chats.chats.last!.count - 1, section: self.chats.chats.count - 1)
                                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
                            }
                        }
                    }
                }
            })
//            メッセージを送信した時間をグループに保存
            var objectClass = ""
            if(selectedChatRoom.isGroup){
                objectClass = "ChatGroup"
            }
            else{
                objectClass = "OneOnOneChat"
            }
            let query = NCMBQuery(className: objectClass)
            query?.whereKey("objectId", equalTo: selectedChatRoom.objectId)
            query?.findObjectsInBackground({ (result, error) in
                if(error == nil){
                    if(result!.count == 0){
                        self.showOkAlert(title: "Error", message: "Could not update!")
                    }
                    else{
                        let object = result!.first as! NCMBObject
                        object.setObject(Date(), forKey: "lastSentDate")
                        object.saveInBackground { (error) in
                            if(error != nil){
                                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                            }
                        }
                    }
                }
                else{
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
        }
    }
    
    func loadChat() {
        let query = NCMBQuery(className: "Chat")
        query?.includeKey("user")
        query?.whereKey("isGroup", equalTo: selectedChatRoom.isGroup)
        query?.whereKey("chatGroupId", equalTo: selectedChatRoom.objectId)
        query?.findObjectsInBackground({ (result, error) in
            if(error != nil){
                // エラーが発生したら、
                print("error")
            }
            else{
                // 読み込みが成功したら、
                let chatList = result as! [NCMBObject]
                self.chats.makeChats(chatList)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.tableView.reloadData()
                    DispatchQueue.main.async {
                        if(self.chats.chats.last != nil){
                            let indexPath = IndexPath(row: self.chats.chats.last!.count - 1, section: self.chats.chats.count - 1)
                            self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
                        }
                    }
                }
            }
        })
    }
    
    
    @objc func update(){
        self.loadChat()
    }
    
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "UserList", sender: nil)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "UserList":
            let view2 = segue.destination as! SearchUserForCreateGroupViewController
            view2.selectedChatRoom = selectedChatRoom
        default:
            break
        }
    }
    
}

extension ChatViewController {
    func setupUI() {
        tableView.backgroundColor = UIColor(red: 113/255, green: 148/255, blue: 194/255, alpha: 1)
        
        tableView.separatorColor = UIColor.clear // セルを区切る線を見えなくする
        tableView.estimatedRowHeight = 10000 // セルが高さ以上になった場合バインバインという動きをするが、それを防ぐために大きな値を設定
        tableView.rowHeight = UITableView.automaticDimension // Contentに合わせたセルの高さに設定
        tableView.allowsSelection = false // 選択を不可にする
        tableView.keyboardDismissMode = .interactive // テーブルビューをキーボードをまたぐように下にスワイプした時にキーボードを閉じる
        
        tableView.register(UINib(nibName: "YourGroupChatViewCell", bundle: nil), forCellReuseIdentifier: "YourGroupChat")
        tableView.register(UINib(nibName: "YourChatViewCell", bundle: nil), forCellReuseIdentifier: "YourChat")
        tableView.register(UINib(nibName: "MyChatViewCell", bundle: nil), forCellReuseIdentifier: "MyChat")
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.chats[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats.chats[indexPath.section][indexPath.row]
        if(chat.isFromMe){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChat") as! MyChatViewCell
            cell.textView.text = chat.message
            cell.timeLabel.text = chat.sentTime
//            未読・既読の表示
            if chat.numOfRead == 0 {
                cell.readLabel.text = "未読"
            }
            else if(chat.isGroup){
                cell.readLabel.text = "既読" + chat.numOfRead.s
            }
            else{
                cell.readLabel.text = "既読"
            }
            return cell
        }
        else if(selectedChatRoom.isGroup){
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourGroupChat") as! YourGroupChatViewCell
            cell.userNameLabel.text = chat.userName
            cell.textView.text = chat.message
            cell.timeLabel.text = chat.sentTime
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChat") as! YourChatViewCell
            cell.textView.text = chat.message
            cell.timeLabel.text = chat.sentTime
            return cell
        }
    }
    
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int{
        return chats.chats.count
    }
    //セクションのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return chats.dates[section]
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
}
