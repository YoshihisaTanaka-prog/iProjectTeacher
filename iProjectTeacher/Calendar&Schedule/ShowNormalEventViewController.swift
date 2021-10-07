//
//  EditNormalEventViewController.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/08/02.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class ShowNormalEventViewController: UIViewController, UITableViewDataSource {
    
    var schedule: Schedule!
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var detailTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = schedule.title
        detailTextView.text = schedule.detail
        detailTextView.isEditable = false
        detailTextView.isSelectable = false
        
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100.f
        
        setBackGround(true, true)
        
        switch schedule.eventType {
        case "school":
            self.navigationItem.title = "学校の予定"
        case "private":
            self.navigationItem.title = "個人的な予定"
        default:
            break
        }

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.detailTimeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let dates = schedule.detailTimeList[indexPath.row]
        cell.textLabel?.text = dates[0].ymdJp + dates[0].hmJp + "\n|\n" + dates[1].ymdJp + dates[1].hmJp
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.textAlignment = .center
        cell.setFontColor()
        return cell
    }

}
