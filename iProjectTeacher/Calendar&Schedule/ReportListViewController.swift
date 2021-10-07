//
//  ReportListViewController.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/09/26.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class ReportListViewController: UIViewController {
    
    var reportList = [Report]()
    private var selectedReport: Report!
    
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib2 = UINib(nibName: "ReportTableViewCell", bundle: Bundle.main)
        tableView.register(nib2, forCellReuseIdentifier: "Report")
        tableView.rowHeight = 95.f
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        setBackGround(true, true)
    }
}

extension ReportListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Report") as! ReportTableViewCell
        
        let report = reportList[indexPath.row]
        
        let ud = UserDefaults.standard
        cell.userimage.image = ud.image(forKey: report.teacher.userId)
        cell.userNameLabel.text = report.teacher.userName
        cell.subject.text = report.subject
        
        cell.setFontColor()
        cell.backgroundColor = dColor.base
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedReport = reportList[indexPath.row]
        self.performSegue(withIdentifier: "Report", sender: nil)
        tableView.reloadData()
    }
}
    
extension ReportListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view2 = segue.destination as! ReportViewController
        view2.report = selectedReport
    }
}
