//
//  ChatTableViewController.swift
//  ChatTest3
//
//  Created by 田中義久 on 2021/08/20.
//

import UIKit
import NCMB

class ChatTableViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    private var selectedChatRoom: ChatRoom!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTableView()
        
        setBackGround(true, true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

}

extension ChatTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    private func setTableView(){
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: "ChatRoomTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomsG.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChatRoomTableViewCell
        cell.roomNameLabel.text = chatRoomsG[indexPath.row].roomName
        let ud = UserDefaults.standard
        cell.iconImageView.image = ud.image(forKey: chatRoomsG[indexPath.row].imageId)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChatRoom = chatRoomsG[indexPath.row]
        self.performSegue(withIdentifier: "GoToChatRoom", sender: nil)
    }
    //セルのスワイプでの編集を許可（ブロック用）
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        if indexPath.row == 0{
//            サポートセンターはブロックできない
            return false
        }
//        1on1チャットのみブロック可能
        return !chatRoomsG[indexPath.row].isGroup
    }
    
    //スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let chatRoom = chatRoomsG[indexPath.row]
            var blockUserId = ""
            if chatRoom.userInfo[0][0] == currentUserG.userId{
                blockUserId = chatRoom.userInfo[1][0]
            }
            if chatRoom.userInfo[1][0] == currentUserG.userId{
                blockUserId = chatRoom.userInfo[0][0]
            }
            if blockUserId != ""{
//                afterActionの後のコードはアラートで「はい」を押した時のみ実行される部分
                blockUserAlert(userId: blockUserId, chatRoomId: chatRoom.id, afterAction: {
                    DispatchQueue.main.async {
                        chatRoomsG.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
                    }
                })
            }
        }
    }
//    スワイプした時に表示される文言の上書き
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt: IndexPath) -> String? {
        return "ブロック"
    }
}

extension ChatTableViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GoToChatRoom":
            let nextVC = segue.destination as! ChatViewController
            nextVC.sentChatRoom = selectedChatRoom
            nextVC.sentChatRoom.delegate = nextVC
            nextVC.sentChatRoom.loadChats()
        default:
            break
        }
    }
}
