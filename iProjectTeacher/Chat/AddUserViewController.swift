//
//  AddUserViewController.swift
//  ChatTest4
//
//  Created by 田中義久 on 2021/08/22.
//

import UIKit
import NCMB

class AddUserViewController: UIViewController {
    
    var beforeVC: ChatViewController!
    var object: NCMBObject!
    
    private var ignoerUserIds = [String]()
    private var users = [User]()
    private var isInvitedUsers = [Bool]()
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for ui in beforeVC.sentChatRoom.userInfo{
            ignoerUserIds.append(ui[0])
        }
        
        loadFolloingUser()
        
        tableView.dataSource = self

        tableView.rowHeight = 100
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: "InviteUserTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        setBackGround(false, false)
    }
    
    private func loadFolloingUser(){
        for u in mixFollowList(){
            if !ignoerUserIds.contains(u.userId){
                users.append(u)
                isInvitedUsers.append(false)
            }
        }
    }
}

extension AddUserViewController: UITableViewDataSource, InviteUserTableViewCellDelegate{
    
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


extension AddUserViewController{
    @IBAction func tappedButton(){
        button.isEnabled = false
        for isInvited in isInvitedUsers{
            if isInvited{
                let object = NCMBObject(className: "ChatRoom", objectId: beforeVC.sentChatRoom.id)
                for u in users{
                    beforeVC.sentChatRoom.userInfo.append([u.userId, u.userName])
                }
                object?.setObject(beforeVC.sentChatRoom.userInfo, forKey: "userInfo")
                object?.saveInBackground({ error in
                    if error == nil{
                        let id = object?.objectId!
                        for u in self.users{
                            let object = NCMBObject(className: "UserChatRoom")
                            object?.setObject(id, forKey: "chatRoomId")
                            object?.setObject(u.userId != currentUserG.userId, forKey: "isFirst")
                            object?.setObject(u.userId, forKey: "userId")
                            var error: NSError? = nil
                            object?.save(&error)
                            if error != nil{
                                self.showOkAlert(title: "Saving user list data error", message: error!.localizedDescription)
                                self.button.isEnabled = true
                                return
                            }
                        }
                        self.dismiss(animated: true, completion: nil)
                    } else{
                        self.showOkAlert(title: "Saving user list data error", message: error!.localizedDescription)
                        self.button.isEnabled = true
                    }
                })
                return
            }
        }
        button.isEnabled = true
    }
}
