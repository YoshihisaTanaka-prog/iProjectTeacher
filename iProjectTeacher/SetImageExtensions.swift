//
//  SetImageExtensions.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/06/04.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher

extension UIViewController{
    func setUserImage(_ imageView: inout UIImageView, _ user: User){
        if user.teacherParameter == nil{
            imageView.image = userImagesCacheG[user.ncmb.objectId] ?? UIImage(named: "studentNoImage.png")
        }
        else{
            imageView.image = userImagesCacheG[user.ncmb.objectId] ?? UIImage(named: "teacherNoImage.png")
        }
        if user.imageName != nil {
            if user.teacherParameter == nil{
                imageView.kf.setImage(with: URL(string: "https://mbaas.api.nifcloud.com/2013-09-01/applications/LEaF9q0Coe9T8EYl/publicFiles/" + user.ncmb.objectId), placeholder: userImagesCacheG[user.ncmb.objectId] ?? UIImage(named: "studentNoImage.png"))
            }
            else{
                imageView.kf.setImage(with: URL(string: "https://mbaas.api.nifcloud.com/2013-09-01/applications/LEaF9q0Coe9T8EYl/publicFiles/" + user.ncmb.objectId), placeholder: userImagesCacheG[user.ncmb.objectId] ?? UIImage(named: "teacherNoImage.png"))
            }
        }
    }
}
