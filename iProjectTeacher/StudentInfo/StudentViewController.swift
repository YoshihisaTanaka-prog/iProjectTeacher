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
class StudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private var tableView: UITableView!
    
    var selectedStudent: User!

    private var students = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGround(true, true)
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100.f
        
        let nib = UINib(nibName: "StudentInfoTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "Cell2")
//        /Users/tanakayoshihisa/iProjectStudent/iProjectStudent/Teacher
        setBackGround(true, true)
        students = mixFollowList()
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! StudentInfoTableViewCell
        cell.highSchool.text = students[indexPath.row].studentParameter!.schoolName + " " + transformGrade(students[indexPath.row].grade)
        cell.highSchool.numberOfLines = 0
        cell.userNameLabel.text = students[indexPath.row].userName
        cell.userNameFuriganaLabel.text = students[indexPath.row].furigana
        cell.userimage.image = userImagesCacheG[students[indexPath.row].userId]  //ユーザー画像を設定
        
        cell.setFontColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStudent = students[indexPath.row]
        self.performSegue(withIdentifier: "Detail", sender: nil)
    }

}
