//
//  CreateGroupViewController.swift
//  ChatTest2
//
//  Created by 田中義久 on 2021/01/22.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class CreateGroupViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedList(){
        self.performSegue(withIdentifier: "ShowUserList", sender: nil)
    }
    
    @IBAction func tappedCreate(){
        let groupObject = NCMBObject(className: "ChatGroup")
        groupObject?.setObject(Date(), forKey: "lastSentDate")
        groupObject?.setObject(textField!.text, forKey: "name")
        groupObject?.saveInBackground({ (error) in
            if(error == nil){
                let userGroupObject = NCMBObject(className: "UserChatGroup")
                userGroupObject?.setObject(groupObject!, forKey: "chatGroup")
                userGroupObject?.setObject(groupObject!.objectId, forKey: "chatGroupId")
                userGroupObject?.setObject(true, forKey: "isGroup")
                userGroupObject?.setObject(true, forKey: "isPermited")
                userGroupObject?.setObject(NCMBUser.current()!, forKey: "user")
                userGroupObject?.saveInBackground({ (error) in
                    if(error == nil){
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        self.showOkAlert(title: "Error", message: error!.localizedDescription)
                    }
                })
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }

}
