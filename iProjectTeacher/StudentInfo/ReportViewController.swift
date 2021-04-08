//
//  ReportViewController.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/04/04.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import Cosmos
import NCMB

class ReportViewController: UIViewController {
    
    var lesson: String?
    var report: Report?
    
    private var subjectLabel: UILabel!
    private var unitLabel: UILabel!
    private var attitude = 0
    private var homeworkTextField: UITextField!
    private var nextUnitPickerView: UIPickerView!
    private var nextUnitList:[[String]] = []
    private var selectedNextUnit = ""
    private var messageToParentsTextField: UITextField!
    private var messageToTeacherTextField: UITextField!
    private var nextLesson: String?
    
    private var cosmos: CosmosView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cosmos.didTouchCosmos = { rating in
            self.attitude = rating.i
        }
        // ビューから指を離した時に呼ばれる
        cosmos.didFinishTouchingCosmos = { rating in
            self.attitude = rating.i
        }
    }
    
    func save() {
        if report == nil{
            let object = NCMBObject(className: "Report")
            object?.setObject(subjectLabel.text, forKey: "subject")
            object?.setObject(unitLabel.text, forKey: "unit")
            object?.setObject(attitude, forKey: "attitude")
            object?.setObject(homeworkTextField.text, forKey: "homework")
            object?.setObject(selectedNextUnit, forKey: "nextUnit")
            object?.setObject(messageToParentsTextField.text, forKey: "messageToParents")
            object?.setObject(messageToTeacherTextField.text, forKey: "messageToTeacher")
            object?.saveInBackground({ (error) in
                if(error == nil){
//                    ページ遷移
                } else {
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
//            メールを送信
        }
        else{
//            これいる？
            let object = NCMBObject(className: "Report", objectId: report!.objectId)
            object?.setObject(attitude, forKey: "attitude")
            object?.setObject(homeworkTextField.text, forKey: "homework")
            object?.setObject(messageToParentsTextField.text, forKey: "messageToParents")
            object?.setObject(messageToTeacherTextField.text, forKey: "messageToTeacher")
            object?.saveInBackground({ (error) in
                if(error == nil){
//                    ページ遷移
                } else {
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
        }
    }

}
