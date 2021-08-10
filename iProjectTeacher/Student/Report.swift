//
//  Report.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/02/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import NCMB

protocol ReportDelegate {
    func imagesDidLoad(images: [UIImage])
}

class Report{
    var ncmb: NCMBObject
    var studentId: String
    var student: User
    var teacherId: String
    var teacher: User
    var subject: String
    var unit: String
    var attitude: String
    var homework: String
    var nextUnit: String
    var messageToParents: String
    var messageToTeacher: String
    var fileNames: [String] = []
    var delegate: ReportDelegate?
    
    init(_ report: NCMBObject){
        self.ncmb = report
        self.studentId = report.object(forKey: "studentId") as! String
        self.teacherId = report.object(forKey: "teacherId") as! String
        self.student = User(userId: studentId, isNeedParameter: true, viewController: UIViewController())
        self.teacher = User(userId: teacherId, isNeedParameter: true, viewController: UIViewController())
        self.subject = report.object(forKey: "subject") as! String
        self.unit = report.object(forKey: "unit") as! String
        self.attitude = report.object(forKey: "attitude") as! String
        self.homework = report.object(forKey: "homework") as! String
        self.nextUnit = report.object(forKey: "nextUnit") as! String
        self.messageToParents = report.object(forKey: "messageToParents") as! String
        self.messageToTeacher = report.object(forKey: "messageToTeacher") as! String
        self.fileNames = report.object(forKey: "fileNames") as? [String] ?? []
    }
    
    init(studentId: String, teacherId: String, subject: String, unit: String, attitude: String, homework: String, nextUnit: String, messageToParents: String, messageToTeacher: String){
        self.ncmb = NCMBObject(className: "Report")!
        self.studentId = studentId
        self.student = User(userId: studentId, isNeedParameter: true, viewController: UIViewController())
        self.teacherId = teacherId
        self.teacher = User(userId: teacherId, isNeedParameter: true, viewController: UIViewController())
        self.subject = subject
        self.unit = unit
        self.attitude = attitude
        self.homework = homework
        self.nextUnit = nextUnit
        self.messageToParents = messageToParents
        self.messageToTeacher = messageToTeacher
    }
    
    func loadImage(vc: UIViewController){
        var loadedImage: [Int: UIImage] = [:]
        var isLoaded = [Bool]()
        for _ in fileNames{
            isLoaded.append(false)
        }
        for i in 0..<fileNames.count{
            let fileName = fileNames[i]
            let file = NCMBFile.file(withName: fileName, data:nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        isLoaded[i] = true
                        let image = UIImage(data: data!)
                        loadedImage[i] = image
                        var isNeedToCallDelegate = true
                        for l in isLoaded{
                            if !l {
                                isNeedToCallDelegate = false
                                break
                            }
                        }
                        if isNeedToCallDelegate{
                            var images = [UIImage]()
                            for i in 0..<isLoaded.count{
                                if let image = loadedImage[i]{
                                    images.append(image)
                                }
                            }
                            self.delegate?.imagesDidLoad(images: images)
                        }
                    }
                } else {
                    vc.showOkAlert(title: "Loading image error", message: error!.localizedDescription)
                }
            }
        }
    }
    
}
