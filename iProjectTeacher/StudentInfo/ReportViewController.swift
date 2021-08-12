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

class ReportViewController: UIViewController,ReportDelegate {
    func imagesDidLoad(images: [UIImage]) {
        self.images = images
    }
    
    
    var report: Report!
    
    @IBOutlet private var subjectLabel: UILabel!
    @IBOutlet private var unitLabel: UILabel!
    @IBOutlet private var attitudeLabel: UILabel!
    //private var attitude = 0
    @IBOutlet private var homeworkLabel: UILabel!
    @IBOutlet private var nextUnitLabel: UILabel!
    private var nextUnitList:[[String]] = []
    private var selectedNextUnit = ""
    @IBOutlet private var messageToParentsLabel: UILabel!
    @IBOutlet private var messageToTeacherLabel: UILabel!
    private var nextLesson: String?
    
    @IBOutlet private var file: UIButton!
    private var images = [UIImage]()
    
    
    //@IBOutlet var cosmos: CosmosView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectLabel.text = report.subject
        unitLabel.text = report.unit
        attitudeLabel.text = report.attitude
        homeworkLabel.text = report.homework
        nextUnitLabel.text = report.nextUnit
        messageToParentsLabel.text = report.messageToParents
        messageToTeacherLabel.text = report.messageToTeacher

        if report.fileNames.count == 0 {
            file.isHidden = true
        }
        
        
        // Do any additional setup after loading the view.
//        cosmos.didTouchCosmos = { rating in
//            self.attitude = rating.i
//        }
        // ビューから指を離した時に呼ばれる
//        cosmos.didFinishTouchingCosmos = { rating in
//            self.attitude = rating.i
//        }
    }
    

}
