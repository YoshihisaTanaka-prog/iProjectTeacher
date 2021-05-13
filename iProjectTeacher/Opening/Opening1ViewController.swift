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
    
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = dColor.opening
        label.alpha = 0.f
        isLogInG = false
        let ud = UserDefaults.standard
//        まず、端末上にNCMBUser.current()の情報があるか確認
        if let u = NCMBUser.current(){
//            次に、パスワードが端末上に保存されているかどうか確認
            if let p = ud.string(forKey: u.mailAddress){
//                さらに、時間が経過し過ぎていないかどうか確認
                let d = ud.object(forKey: u.mailAddress + "time") as! Date
                let now = Date()
                let elapsedDays = Calendar.current.dateComponents([.day], from: d, to: now).day //以前ログインしてからの経過日数を計算
                if( elapsedDays! < 2 ){
//                    条件を全て満たしていたら再ログインする。
                    NCMBUser.logInWithMailAddress(inBackground: u.mailAddress, password: p) { (user, error) in
                        if error == nil{
//                            次回のログイン判定のために「以前ログインした時間」を保存する部分を今の時間に上書きする。
                            ud.set(now, forKey: u.mailAddress + "time")
                            ud.synchronize()
//                            フォロワーを読み込む
                            self.loadFollowlist()
//                            ログインしていることを次のViewに伝える、ログイン中のユーザーの情報を保存する。
                            DispatchQueue.main.async {
                                isLogInG = true
                                currentUserG = User(user!)
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
        UIView.animate(withDuration: 0.8, animations: {
            self.label.alpha = 1.f
        }) { _ in
//            ナビゲーションバーがある場合の画面サイズを取得するために画面遷移を行う
            let storyboad = UIStoryboard(name: "Opening", bundle: nil)
            let nextTC = storyboad.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(nextTC, animated: false, completion: nil)
        }
    }

}
