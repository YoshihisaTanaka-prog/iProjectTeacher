//
//  OpeningViewController.swift
//  opening
//
//  Created by 田中義久 on 2021/01/30.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class Opening1ViewController: UIViewController {
    
    private var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = dColor.opening
        
        isLogInG = false
        let ud = UserDefaults.standard
        
        if !ud.bool(forKey: "didSetUp-v1.0.0"){
            ud.setValue(true, forKey: "didSetUp-v1.0.0")
            ud.saveImage(image: UIImage(named: "iconN.png"), forKey: "sapo-to")
        }
        
        let isLogin = ud.bool(forKey: "isLogin")
        if ud.image(forKey: "sapo-to") == nil{
            ud.saveImage(image: UIImage(named: "iconN.png"), forKey: "sapo-to")
        }
        if isLogin{
//            まず、端末上にNCMBUser.current()の情報があるか確認
            if let u = NCMBUser.current(){
                let mailAddress = u.mailAddress!
//                次に、パスワードが端末上に保存されているかどうか確認
                if let p = ud.string(forKey: mailAddress){
//                    さらに、時間が経過し過ぎていないかどうか確認
                    let d = ud.object(forKey: mailAddress + "time") as! Date
                    let now = Date()
                    let elapsedDays = Calendar.current.dateComponents([.day], from: d, to: now).day //以前ログインしてからの経過日数を計算
                    if( elapsedDays! < 2 ){
//                        条件を全て満たしていたら再ログインする。
                        NCMBUser.logInWithMailAddress(inBackground: mailAddress, password: p) { (user, error) in
                            if error == nil{
                                
                                currentUserG = User(userId: NCMBUser.current()!.objectId, isNeedParameter: true, viewController: self)
//                                次回のログイン判定のために「以前ログインした時間」を保存する部分を今の時間に上書きする。
                                ud.set(now, forKey: mailAddress + "time")
                                ud.set(true, forKey: "isLogin")
                                ud.synchronize()
//                                ログインしていることを次のViewに伝える、ログイン中のユーザーの情報を保存する。
                                isLogInG = true
                            } else {
                                print(error!.localizedDescription)
                            }
                        }
                    } else{
//                        一旦ログアウト
                        NCMBUser.logOutInBackground { (error) in
                            if error != nil{
                                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        画面サイズの取得
        screenSizeG["NnNt"] = Size(x: self.view.frame.size.width, y: self.view.frame.size.height, tm: self.view.safeAreaInsets.top, bm: self.view.safeAreaInsets.bottom)
        print("NnNt", screenSizeG["NnNt"]!.viewHeight)
        
        let x = screenSizeG["NnNt"]!.width
        let y = screenSizeG["NnNt"]!.screenHeight
        let length = min(x, 500.f)
        imageView.frame = CGRect(x: 0, y: 0, width: length*0.8, height: length*0.8)
        imageView.layer.cornerRadius = length / 10.f
        imageView.clipsToBounds = true
        imageView.center = CGPoint(x: x / 2.f, y: y / 2.f)
        imageView.image = UIImage(named: "iconN.png")
        imageView.alpha = 0.f
        self.view.addSubview(imageView)
            
        UIView.animate(withDuration: 0.8, animations: {
            self.imageView.alpha = 1.f
        }) { _ in
//            ナビゲーションバーがある場合の画面サイズを取得するために画面遷移を行う
            let storyboad = UIStoryboard(name: "Opening", bundle: nil)
            let nextTC = storyboad.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(nextTC, animated: false, completion: nil)
        }
    }

}
