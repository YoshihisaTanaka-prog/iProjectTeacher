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
        // Do any additional setup after loading the view.
        self.view.backgroundColor = dColor.opening
        label.alpha = 0.f
        let _ = NCMBUser.current()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let _ = NCMBUser.current()
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
