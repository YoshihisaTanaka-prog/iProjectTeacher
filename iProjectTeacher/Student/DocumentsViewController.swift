//
//  DocumentsViewController.swift
//  iProjectTeacher
//
//  Created by Kaori Nakamura on 5/20/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class DocumentsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private var documentImage: UIImageView!
    @IBOutlet private var pageLabel: UILabel!
    @IBOutlet private var pulusButton: UIButton!
    @IBOutlet private var minusButton: UIButton!
    @IBOutlet private var item: UIBarButtonItem!
    
    private var selectedImages: [UIImage] = []
    private var pageNum = -1
    private var maxPageNum = 0
    var report: Report!
    var lectureId: String!

    override func viewDidLoad() {
        let object = report.ncmb
        object.setObject(report.studentId, forKey: "studentId")
        object.setObject(report.teacherId, forKey: "teacherId")
        object.setObject(report.subject, forKey: "subject")
        object.setObject(report.unit, forKey: "unit")
        object.setObject(report.attitude, forKey: "attitude")
        object.setObject(report.homework, forKey: "homework")
        object.setObject(report.nextUnit, forKey: "nextUnit")
        object.setObject(report.messageToParents, forKey: "messageToParents")
        object.setObject(report.messageToTeacher, forKey: "messageToTeacher")
        object.saveInBackground { error in
            if error == nil{
                self.report = Report(object)
            } else {
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackGround(true, false)
        
        pulusButton.alpha = 0.5.f
        pulusButton.isEnabled = false
        minusButton.alpha = 0.5.f
        minusButton.isEnabled = false
    }
    

    @IBAction func selectImage() {
        let actionController = UIAlertController(title: "画像の選択", message: "選択して下さい", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            //カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                self.showOkAlert(title: "エラー", message: "この機種ではカメラが使用出来ません。")
            }
        }
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            //アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                self.showOkAlert(title: "エラー", message: "この機種ではフォトライブラリが使用出来ません。")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func tappedPlus(){
        pageNum += 1
        minusButton.alpha = 1.f
        minusButton.isEnabled = true
        setPage(pageNum: pageNum)
        if pageNum == maxPageNum - 1{
            pulusButton.alpha = 0.5.f
            pulusButton.isEnabled = false
        }
    }
    
    @IBAction func tappedMinus(){
        pageNum -= 1
        pulusButton.alpha = 1.f
        pulusButton.isEnabled = true
        setPage(pageNum: pageNum)
        if pageNum == 0{
            minusButton.alpha = 0.5.f
            minusButton.isEnabled = false
        }
    }
    
    @IBAction func saveUserInfo(){
        item.isEnabled = false
        if selectedImages.count != 0 {
            let photos = selectedImages
            for i in 0..<photos.count {
                let photo = photos[i]
                let size = NSData(data: photo.pngData()!).count.d
                let scale = Float(sqrt(min(1.d, 200000.d / size)))
                let resizedImage = photo.scale(byFactor: scale)
                let data = UIImage.pngData(resizedImage!)
                let fileName = report.ncmb.objectId + "-" + String(i+1) + ".png"
                report.fileNames.append(fileName)
                let file = NCMBFile.file(withName: fileName, data: data()) as! NCMBFile
                file.saveInBackground { (error) in
                    if error != nil{
                        self.showOkAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                    print("success")
                    }
                } progressBlock: { (progress) in
                    print(progress)
                }
            }
        }
        
        let object = report.ncmb
        object.setObject(report.fileNames, forKey: "fileNames")
        object.saveInBackground{ (error) in
            if error != nil {
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                self.item.isEnabled = true
            } else {
                let lectureObject = NCMBObject(className: "Lecture", objectId: self.lectureId)
                lectureObject?.setObject(object.objectId, forKey: "reportId")
                lectureObject?.saveInBackground({ error in
                    if error == nil{
                        self.showOkAlert(title: "報告", message: "保護者様に送信いたします。"){
                            self.sendReportEmailToParent(object.objectId)
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController")
                            self.present(rootViewController, animated: true, completion: nil)
                        }
                    } else{
                        self.showOkAlert(title: "Error", message: error!.localizedDescription)
                    }
                })
            }
        }
    }
    
    @IBAction func tappedBack(){
        if selectedImages.count == 0{
            self.navigationController?.popViewController(animated: true)
        } else{
            showOkCancelAlert(title: "注意", message: "画像の保存を中止しますか？", okAction: {
                self.navigationController?.popViewController(animated: true)
            }, cancelAction: {
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImages.append(selectedImage)
        setPage()
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func setPage(){
        maxPageNum = selectedImages.count
        pageNum = maxPageNum - 1
        if pageNum == -1{
            documentImage.image = nil
        } else {
            documentImage.image = selectedImages[pageNum]
            pageLabel.text = (pageNum + 1).s + "/" + maxPageNum.s
        }
        if maxPageNum < 2{
            pulusButton.alpha = 0.5.f
            pulusButton.isEnabled = false
            minusButton.alpha = 0.5.f
            minusButton.isEnabled = false
        } else{
            minusButton.alpha = 1.f
            minusButton.isEnabled = true
        }
    }
    
    private func setPage(pageNum: Int){
        self.pageNum = pageNum
        documentImage.image = selectedImages[pageNum]
        pageLabel.text = (pageNum + 1).s + "/" + maxPageNum.s
    }
    
}
