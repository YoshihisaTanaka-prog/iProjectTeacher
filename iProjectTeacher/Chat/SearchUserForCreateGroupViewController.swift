//
//  SearchUserForCreateGroupViewController.swift
//  ChatTest2
//
//  Created by 田中義久 on 2021/01/22.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class SearchUserForCreateGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var users: [NCMBUser] = []
    var selectedUserNumber:[Int] = []
    var selectedChatRoom: ChatRoom!
    
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        loadUser()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        if( selectedUserNumber.contains(indexPath.row) ){
            cell.textLabel?.text = users[indexPath.row].userName + "  (選択中)"
        }
        else{
            cell.textLabel?.text = users[indexPath.row].userName + "  (未選択)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(selectedUserNumber.contains(indexPath.row)){
            var save:[Int] = []
            for i in selectedUserNumber {
                if(i != indexPath.row){
                    save.append(i)
                }
            }
            selectedUserNumber = save
        }
        else{
            selectedUserNumber.append(indexPath.row)
        }
        tableView.reloadData()
    }
    
    func loadUser(){
        let query = NCMBUser.query()
        query?.whereKey("isActive", notEqualTo: false)
        query?.whereKey("objectId", notEqualTo: NCMBUser.current()!.objectId)
        query?.findObjectsInBackground({ (result, error) in
            if(error == nil){
                self.users = []
                let userList = result as! [NCMBUser]
                for user in userList {
                    self.users.append(user)
                }
                self.tableView.reloadData()
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
    
    @IBAction func addUserToGroup(){
        let query = NCMBQuery(className: "ChatGroup")
        query?.whereKey("objectId", equalTo: selectedChatRoom.objectId)
        query?.findObjectsInBackground({ (result, error) in
            if(error == nil){
                if result!.count == 0 {
                    self.showOkAlert(title: "Error", message: "Could not find this chat room!")
                }
                else{
                    for i in self.selectedUserNumber {
                        let chatGroup = result!.first as! NCMBObject
                        let object = NCMBObject(className: "UserChatGroup")
                        object?.setObject(chatGroup, forKey: "chatGroup")
                        object?.setObject(chatGroup.objectId, forKey: "chatGroupId")
                        object?.setObject(true, forKey: "isGroup")
                        object?.setObject(false, forKey: "isPermited")
                        object?.setObject(self.users[i], forKey: "user")
                        object?.saveInBackground({ (error) in
                            if(error != nil){
                                self.showOkAlert(title: "Error in " + self.users[i].userName, message: error!.localizedDescription)
                            }
                        })
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }

}
