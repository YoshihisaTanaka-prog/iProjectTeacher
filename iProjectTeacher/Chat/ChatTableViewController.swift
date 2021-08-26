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
}

extension ChatTableViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GoToChatRoom":
            let nextVC = segue.destination as! ChatViewController
            nextVC.sentChatRoom = selectedChatRoom
            nextVC.sentChatRoom.loadChats()
            nextVC.sentChatRoom.delegate = nextVC
        default:
            break
        }
    }
}
