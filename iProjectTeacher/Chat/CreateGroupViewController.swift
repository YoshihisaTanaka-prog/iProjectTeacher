//
//  CreateGroupViewController.swift
//  ChatTest4
//
//  Created by 田中義久 on 2021/08/22.
//

import UIKit
import NCMB

class CreateGroupViewController: UIViewController {
    
    private var users = [User]()
    private var isInvitedUsers = [Bool]()
    
    @IBOutlet private var createButton: UIButton!
    @IBOutlet private var roomNameTextField: UITextField!
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self

        tableView.rowHeight = 100
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: "InviteUserTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
        loadFolloingUser()
        
        setBackGround(true, true)
    }
    
    private func loadFolloingUser(){
        users = mixFollowList()
        for _ in users{
            isInvitedUsers.append(false)
        }
    }

}

extension CreateGroupViewController{
//    新しいグループを作る関数
    @IBAction func createGroup(){
        if roomNameTextField.text! != "" {
            let roomName = roomNameTextField.text
            roomNameTextField.text = ""
            createButton.isEnabled = false
            let object = NCMBObject(className: "ChatRoom")
            object?.setObject(roomName, forKey: "roomName")
            object?.setObject(Date(), forKey: "lastTimeMessageSent")
            var userInfo = [[currentUserG.userId, currentUserG.userName]]
            for i in 0..<users.count{
                if isInvitedUsers[i]{
                    let u = users[i]
                    userInfo.append([u.userId, u.userName])
                }
            }
            object?.setObject(userInfo, forKey: "userInfo")
            object?.saveInBackground({ error in
                if error == nil{
                    let id = object?.objectId!
                    for u in userInfo{
                        let object = NCMBObject(className: "UserChatRoom")
                        object?.setObject(id, forKey: "chatRoomId")
                        object?.setObject(u[0] == currentUserG.userId, forKey: "isFirst")
                        object?.setObject(u[0], forKey: "userId")
                        var error: NSError? = nil
                        object?.save(&error)
                        if error != nil{
                            self.showOkAlert(title: "Saving user list data error", message: error!.localizedDescription)
                            self.createButton.isEnabled = true
                            self.roomNameTextField.text = roomName
                            return
                        }
                    }
                    chatRoomsG.insert(ChatRoom(chatRoom: object!, self)!, at: 1)
                    self.navigationController?.popViewController(animated: true)
                } else{
                    self.showOkAlert(title: "Saving user list data error", message: error!.localizedDescription)
                    self.createButton.isEnabled = true
                    self.roomNameTextField.text = roomName
                }
            })
        }
    }
}

extension CreateGroupViewController: UITableViewDataSource, InviteUserTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InviteUserTableViewCell
        
        cell.tag = indexPath.row
        cell.delegate = self
        let ud = UserDefaults.standard
        cell.iconImageView.image = ud.image(forKey: users[indexPath.row].userId)
        cell.userNameLabel.text = users[indexPath.row].userName
        cell.isInvitedSwitch.isOn = isInvitedUsers[indexPath.row]
        
        return cell
    }
    
    func tappedSwitch(cell: InviteUserTableViewCell) {
        isInvitedUsers[cell.tag] = !isInvitedUsers[cell.tag]
        tableView.reloadData()
    }
}
