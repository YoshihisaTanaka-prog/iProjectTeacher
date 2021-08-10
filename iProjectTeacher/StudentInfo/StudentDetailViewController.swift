//
//  StudentDetailViewController.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/02/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB


//選ばれた生徒の情報を表示。ここでレポートも表示される。このレポートをタップするとReportViewControllerへ。
class StudentDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StudentInfoTableViewCellDelegate, ScheduleDelegate {
    
    
    var reportList: [Report] = []
    var student: User!
    var size: Size!
    var selectedReport: Report!
    private var isFinishedLoadSchedule = false
    private var isShowingAlertOfLoadingSchedule = false
    private var alert: UIAlertController!
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackGround(true, true)
        
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 10.f
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "StudentInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "StudentInfo")
        tableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "Report")
        size = getScreenSize(isExsistsNavigationBar: true, isExsistsTabBar: true)
        loadReport()
        mixedScheduleG.delegate = self
        mixedScheduleG.delete()
        mixedScheduleG.loadSchedule(date: Date(), userIds: [currentUserG.userId, student.userId], self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 530.f
        }
        else{
            return 95.f
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            //ユーザー情報のセル
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInfo") as! StudentInfoTableViewCell
            cell.userimage.image = userImagesCacheG[student.userId]
            cell.userNameLabel.text = student.userName
            cell.delegate = self
            cell.student = student
            cell.vc = self
            cell.setButtons()
            cell.selectionStyle = .none
            cell.setFontColor()
            cell.backgroundColor = dColor.base
            
            return cell
        }
        else{
            //レポートのセル
            let cell = tableView.dequeueReusableCell(withIdentifier: "Report") as! ReportTableViewCell
            cell.userNameLabel.text = reportList[indexPath.row - 1].student.userName
            cell.subject.text = reportList[indexPath.row - 1].subject
            cell.userimage.image = userImagesCacheG[reportList[indexPath.row  - 1].studentId]
            cell.selectionStyle = .default
            cell.setFontColor()
            cell.backgroundColor = dColor.base
            
            return cell
        }
    }

    //didSelectRowAt: tableViewがタップされたときの処理を行う
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //上から何番目か
        if indexPath.row != 0 {
            selectedReport = reportList[indexPath.row - 1]
            self.performSegue(withIdentifier: "Report", sender: nil)
        }
        tableView.reloadData()
    }
    
    
    func allSchedulesDidLoaded() {}
    func schedulesDidLoaded() {
        self.isFinishedLoadSchedule = true
        if isShowingAlertOfLoadingSchedule{
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "Schedule", sender: nil)
        }
    }
    
    func tappedSchedule() {
        if isFinishedLoadSchedule{
            self.performSegue(withIdentifier: "Schedule", sender: nil)
        } else if !isShowingAlertOfLoadingSchedule{
            isShowingAlertOfLoadingSchedule = true
            alert = UIAlertController(title: "注意", message: "生徒とのスケジュールをロード中です。\nしばらくお待ちください。", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tappedChat() {
        
    }
    
    func tappedChangeStatus() {
        tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "Report":
            let view2 = segue.destination as! ReportViewController
            view2.report = selectedReport
        case "Schedule":
            let view2 = segue.destination as! CalendarViewController
            view2.student = student
        default:
            break
        }
    }
    
}
