//
//  ChatViewController.swift
//  ChatTest3
//
//  Created by 田中義久 on 2021/08/20.
//

import UIKit
import NCMB

class ChatViewController: UIViewController {
    
    var sentChatRoom: ChatRoom!
    var sectionTitles = [String]()
    private var chats = [[Chat]]()
    private var addBarButtonItem: UIBarButtonItem!
    private var isLocked = false
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        グループチャットの場合自分がフォローしているユーザーを追加できる。
        if sentChatRoom.isGroup{
            addBarButtonItem = UIBarButtonItem(title: "メンバーの追加", style: .done, target: self, action: #selector(addBarButtonTapped(_:)))
            self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        }
        
//        未登録のチャットルームの場合チャットを続けるかどうか確認するためのアラートを表示する。
        if sentChatRoom.isFirst{
            showOkCancelAlert(title: "注意", message: "未登録のルームです。チャットを続けますか？", okAction: {
                let query = NCMBQuery(className: "UserChatRoom")
                query?.whereKey("userId", equalTo: currentUserG.userId)
                query?.whereKey("chatRoomId", equalTo: self.sentChatRoom.id)
                query?.findObjectsInBackground({ result, error in
                    if let o = result?.first as? NCMBObject{
                        o.setObject(false, forKey: "isFirst")
                        o.saveInBackground { error in
                            if error == nil{
                                self.sentChatRoom.loadChats()
                            } else{
                                self.showOkAlert(title: "Updating room's status error", message: error!.localizedDescription)
                            }
                        }
                    } else{
                        self.showOkAlert(title: "Loading room's status error", message: error!.localizedDescription)
                    }
                })
            }, cancelAction: {
                self.isLocked = true
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        setupUI()
        
        setBackGround(true, true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = sentChatRoom.roomName
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension ChatViewController{
//    メッセージを送る関数
    @IBAction func tappedSend(){
        if textView.text!.count != 0{
            textView.resignFirstResponder()
            let c = Chat()
            c.delegate = self
            c.sendMessage(message: textView.text, chatRoomId: sentChatRoom.id)
        }
    }
}


extension ChatViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return chats.count
    }
    
//    日付を表示するためのもの
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats[indexPath.section][indexPath.row]
        let ud = UserDefaults.standard
        if chat.sentUserId == currentUserG.userId{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChat") as! MyChatViewCell
            cell.textView.text = chat.message
            cell.timeLabel.text = chat.sentTime.hm
//            未読・既読の表示　numOfReadUserに何人が既読したのかが保存されている。
            if chat.numOfReadUser == 0 {
//                既読人数が0人の場合、「未読」と表示する。
                cell.readLabel.text = "未読"
            }
            else if(sentChatRoom.isGroup){
//                既読人数が0人以外でチャットルームがグループの場合、「既読」と既読件数を表示する。
                cell.readLabel.text = "既読" + chat.numOfReadUser.s
            }
            else{
//                既読人数が0人以外でチャットルームが1on1の場合、「既読」と表示する。
                cell.readLabel.text = "既読"
            }
            return cell
        } else if(sentChatRoom.isGroup){
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourGroupChat") as! YourGroupChatViewCell
            cell.iconImageView.image = ud.image(forKey: chat.sentUserId)
            cell.userNameLabel.text = sentChatRoom.searchUserName(userId: chat.sentUserId)
            cell.textView.text = chat.message
            cell.timeLabel.text = chat.sentTime.hm
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChat") as! YourChatViewCell
            cell.iconImageView.image = ud.image(forKey: chat.sentUserId)
            cell.textView.text = chat.message
            cell.timeLabel.text = chat.sentTime.hm
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
}

// 自作関数たち
extension ChatViewController{
    func setupUI(){
        tableView.dataSource = self
        textView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        tableView.tableFooterView = UIView()
        
        tableView.backgroundColor = UIColor(red: 113/255, green: 148/255, blue: 194/255, alpha: 1)
        
        tableView.separatorColor = .clear // セルを区切る線を見えなくする
        tableView.estimatedRowHeight = 10000 // セルが高さ以上になった場合バインバインという動きをするが、それを防ぐために大きな値を設定
        tableView.rowHeight = UITableView.automaticDimension // Contentに合わせたセルの高さに設定
        tableView.allowsSelection = false // 選択を不可にする
        tableView.keyboardDismissMode = .interactive // テーブルビューをキーボードをまたぐように下にスワイプした時にキーボードを閉じる
        
        tableView.register(UINib(nibName: "YourGroupChatViewCell", bundle: nil), forCellReuseIdentifier: "YourGroupChat")
        tableView.register(UINib(nibName: "YourChatViewCell", bundle: nil), forCellReuseIdentifier: "YourChat")
        tableView.register(UINib(nibName: "MyChatViewCell", bundle: nil), forCellReuseIdentifier: "MyChat")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func update(){
        self.sentChatRoom.loadChats()
    }
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "UserList", sender: nil)
    }
    
//    キーボードが出てきた時に画面を上に動かす関数
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
//    キーボードが消えた時に画面を元の高さに戻す関数
    @objc func keyboardWillHide() {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
}

//チャット用の自作デリゲートたち
extension ChatViewController: ChatDelegate, ChatRoomDelegate{
    func didFinishSendingMessage() {
        textView.text = ""
        sentChatRoom.loadChats()
        loadChatRoom()
    }
    
    func showOkAlertC(title: String, message: String) {
        showOkAlert(title: title, message: message)
    }
    
    func didFinishLoadChats(chats: [Chat]) {
        if !isLocked{
//            チャットを日付ごとに分かれた二重配列に変換する
            self.chats = []
            self.sectionTitles = []
//            self.chatsのi番目に追加する。
            var i = 0
            if chats.count != 0{
                self.chats.append([])
                let c = Calendar(identifier: .gregorian)
                let d = chats[0].sentTime
//                日付が変わったことを判定するために最初のチャットが送信された次の日の0時0分を定義する。
                var nextDate = c.date(from: DateComponents(year: d.y, month: d.m, day: d.d + 1))!
//                チャットが送信された日付を保存
                self.sectionTitles.append(c.date(from: DateComponents(year: d.y, month: d.m, day: d.d))!.ymdJp)
                for chat in chats{
                    if chat.sentTime >= nextDate{
//                        日付が変わったら新しい配列を追加し、チャットを追加する場所を更新する
                        self.chats.append([])
                        i += 1
                        let d = chat.sentTime
//                        日付が変わったことを判定するために最初のチャットが送信された次の日の0時0分を定義する。
                        nextDate = c.date(from: DateComponents(year: d.y, month: d.m, day: d.d + 1))!
//                        チャットが送信された日付を保存
                        self.sectionTitles.append(c.date(from: DateComponents(year: d.y, month: d.m, day: d.d))!.ymdJp)
                    }
                    self.chats[i].append(chat)
                }
                tableView.reloadData()
                
//                    テーブルビューの一番下を表示する
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: self.chats.last!.count - 1, section: self.chats.count - 1)
                    self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
                }
            }
        }
    }
    
    func showOkAlertCR(title: String, message: String) {
        showOkAlert(title: title, message: message)
    }
    
}

extension ChatViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddUserViewController
        nextVC.beforeVC = self
    }
}
