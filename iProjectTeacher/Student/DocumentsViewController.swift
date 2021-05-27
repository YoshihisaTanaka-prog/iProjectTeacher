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
    
    @IBOutlet var documentImage: UIImageView!
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func saveUserInfo(){
        
        if selectedImage != nil {
            let size = NSData(data: selectedImage!.pngData()!).count.d
            let scale = Float(sqrt(min(1.d, 200000.d / size)))
            let resizedImage = selectedImage!.scale(byFactor: scale)
            let data = UIImage.pngData(resizedImage!)
            let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: data()) as! NCMBFile
            file.saveInBackground { (error) in
                if error != nil{
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    
                }
            } progressBlock: { (progress) in
                print(progress)
            }
            
        } else {
            
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.documentImage.image = selectedImage!
        picker.dismiss(animated: true, completion: nil)

        
    }
    
}
