//
//  OpeningViewController.swift
//  opening
//
//  Created by 田中義久 on 2021/01/30.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

class Opening1ViewController: UIViewController {
    
    var sizeX: CGFloat!
    var sizeY: CGFloat!
    var marginTop: CGFloat!
    var marginBottom: CGFloat!
    
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        label.alpha = 0.f
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        画面サイズの取得
        self.sizeX = self.view.frame.size.width //　画面幅を取得
        self.sizeY = self.view.frame.size.height // 画面の高さを取得
        self.marginTop = self.view.safeAreaInsets.top
        self.marginBottom = self.view.safeAreaInsets.bottom
        let y = self.sizeY - self.marginBottom - self.marginTop
        screenSizeG["NnNt"] = Size([sizeX,y])
        print("NnNt", screenSizeG["NnNt"]!.size)
        UIView.animate(withDuration: 0.8, animations: {
            self.label.alpha = 1.f
        }) { _ in
//            ナビゲーションバーがある場合の画面サイズを取得するために画面遷移を行う
            let storyboad = UIStoryboard(name: "Opening", bundle: nil)
            let nextTC = storyboad.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            let nextNC = nextTC.viewControllers![0] as! UINavigationController
            let nextVC = nextNC.topViewController as! Opening2ViewController
            nextVC.sizeX = self.sizeX
            nextVC.sizeY = self.sizeY
            nextVC.marginTop = self.marginTop
            nextVC.marginBottom = self.marginBottom
            self.present(nextTC, animated: false, completion: nil)
        }
    }

}
