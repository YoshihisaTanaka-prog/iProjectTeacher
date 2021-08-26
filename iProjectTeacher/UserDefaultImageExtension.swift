//
//  UserDefaultImageExtension.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/08/26.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

extension UserDefaults {
    // 保存したいUIImage, 保存するUserDefaults, Keyを取得
    func saveImage(image: UIImage?, forKey: String) {
        // UIImageをData型へ変換
        if image != nil{
            let nsdata = image!.pngData()
            // UserDefaultsへ保存
            self.set(nsdata, forKey: forKey)
            self.synchronize()
        }
    }
    // 参照するUserDefaults, Keyを取得, UIImageを返す
    func image(forKey: String) -> UIImage? {
        // UserDefaultsからKeyを基にData型を参照
        let data = self.data(forKey: forKey)
        // UIImage型へ変換
        if data == nil{
            return nil
        }
        let returnImage = UIImage(data: data!)
        // UIImageを返す
        return returnImage
    }

}
