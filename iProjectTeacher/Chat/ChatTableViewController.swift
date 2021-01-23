//
//  ChatTableViewController.swift
//  ChatTest
//
//  Created by 田中義久 on 2021/01/12.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class ChatTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var chatRooms:[ChatRoom] = []
    var chatRoomsFromUser:[ChatRoom] = []
    var selectedChatRoom:ChatRoom?
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        if selectedChatRoom != nil {
            self.performSegue(withIdentifier: "GoToRoom", sender: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadChatRoom()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = chatRooms[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedChatRoom = chatRooms[indexPath.row]
        self.performSegue(withIdentifier: "GoToRoom", sender: nil)
    }
    
    func loadChatRoom() {
        let query = NCMBQuery(className: "UserChatGroup")
        query?.includeKey("user")
        query?.includeKey("chatGroup")
        query?.whereKey("user", equalTo: NCMBUser.current()!)
        query?.findObjectsInBackground({ (result, error) in
            if(error == nil){
                self.chatRooms = []
                let chatRoomList = result as! [NCMBObject]
                for chatRoom in chatRoomList {
                    let chatRoomObject = chatRoom.object(forKey: "chatGroup") as! NCMBObject
                    let isGroup = chatRoom.object(forKey: "isGroup") as! Bool
                    self.chatRooms.append(ChatRoom(chatRoomObject, isGroup))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.tableView.reloadData()
                }
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
    
    func loadChatRoomFromUser() {
        let query = NCMBUser.query()
        query?.whereKey("objectId", notEqualTo: NCMBUser.current()!.objectId)
        query?.findObjectsInBackground({ (result, error) in
            if(error == nil){
                let users = result as! [NCMBUser]
                for user in users {
                    self.chatRoomsFromUser.append(ChatRoom(User(user)))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.tableView.reloadData()
                }
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
    
    @IBAction func tappedPlus(){
        self.performSegue(withIdentifier: "MakeGroup", sender: nil)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "GoToRoom":
            let view2 = segue.destination as! ChatViewController
            view2.selectedChatRoom = selectedChatRoom!
        default:
            break
        }
    }
}
