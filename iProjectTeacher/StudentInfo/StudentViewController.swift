//
//  StudentViewController.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/02/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

//生徒一覧を出す。
class StudentViewController: UIViewController {
    
    var selectedStudent: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGround(false, true)
        
//        let query = NCMBUser.query()
//        query?.includeKey("parameter")
//        query?.whereKey("objectId", equalTo: "MT1ys6rPTWdg4LMp")
//        query?.findObjectsInBackground({ (result, error) in
//            if error == nil {
//                let user = result!.first! as! NCMBUser
//                self.selectedStudent = User(user)
//                self.performSegue(withIdentifier: "Detail", sender: nil)
//            }
//            else{
//                self.showOkAlert(title: "Error", message: error!.localizedDescription)
//            }
//        })
        

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "Detail":
            let view2 = segue.destination as! StudentDetailViewController
            view2.student = selectedStudent
        default:
            break
        }
    }

}
