//
//  ReportImageViewController.swift
//  iProjectTeacher
//
//  Created by Kaori Nakamura on 8/12/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class ReportImageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private var documentImage: UIImageView!
    @IBOutlet private var minusButton: UIButton!
    @IBOutlet private var plusButton: UIButton!
    //@IBOutlet private var deleteButton: UIButton!
    
    private var pageNum = 0
    
    var selectedImages: [UIImage] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        documentImage.image = selectedImages[0]
        minusButton.alpha = 0.5.f
        minusButton.isEnabled = false
        if selectedImages.count == 1 {
            plusButton.alpha = 0.5.f
            plusButton.isEnabled = false
        }
        setBackGround(true, true)
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.documentImage.image = selectedImage
        selectedImages.append(selectedImage)
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func tappedPlus(){
            pageNum += 1
            minusButton.alpha = 1.f
            minusButton.isEnabled = true
            setPage(pageNum: pageNum)
        if pageNum == selectedImages.count - 1{
                plusButton.alpha = 0.5.f
                plusButton.isEnabled = false
            }
        }
        
    @IBAction func tappedMinus(){
            pageNum -= 1
            plusButton.alpha = 1.f
            plusButton.isEnabled = true
            setPage(pageNum: pageNum)
            if pageNum == 0{
                minusButton.alpha = 0.5.f
                minusButton.isEnabled = false
            }
        }
    
    @IBAction func delete(){
        for i in (0 ..< pageNum){
            if pageNum == i{
                selectedImages.remove(at: i)
            }
    }
    }
    
    
    private func setPage(pageNum: Int){
            self.pageNum = pageNum
            documentImage.image = selectedImages[pageNum]
//            pageLabel.text = (pageNum + 1).s + "/" + selectedImages.count.s
        }
}
