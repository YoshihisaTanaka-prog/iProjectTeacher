//
//  StudentDetailViewController.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/02/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class StudentDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reportList: [Report] = []
    var student: User!
    var size: Size!
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGround(true, true)
        
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 10.f
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "StudentInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "StudentInfo")
        tableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "Report")
        size = getScreenSize(isExsistsNavigationBar: true, isExsistsTabBar: true)
        loadReport()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return size.viewHeight
        }
        else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInfo") as! StudentInfoTableViewCell
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Report") as! ReportTableViewCell
            cell.titleLabel.text = reportList[indexPath.row - 1].studentId
            return cell
        }
    }
    
    func loadReport(){
        let query = NCMBQuery(className: "Report")
        query?.whereKey("studentId", equalTo: student.userId)
        query?.findObjectsInBackground({ (result, error) in
            if(error == nil){
                self.reportList = []
                let objects = result as! [NCMBObject]
                for o in objects {
                    self.reportList.append(Report(o))
                }
                self.tableView.reloadData()
            }
            else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
    }
}
