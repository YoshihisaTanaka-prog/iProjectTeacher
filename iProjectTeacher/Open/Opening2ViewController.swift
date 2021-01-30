//
//  Opening2ViewController.swift
//  opening
//
//  Created by 田中義久 on 2021/01/30.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class Opening2ViewController: UIViewController {
    
    var sizeX: CGFloat!
    var sizeY: CGFloat!
    var marginTop: CGFloat!
    var marginBottom: CGFloat!
    
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        TabBarやNavigationBarがある時の画面サイズの取得
        screenSizeG["NnEt"] = Size([sizeX, sizeY - marginTop - self.view.safeAreaInsets.bottom])
        screenSizeG["EnNt"] = Size([sizeX, sizeY - marginBottom - self.view.safeAreaInsets.top])
        screenSizeG["EnEt"] = Size([sizeX, sizeY - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom])
        print("NnEt", screenSizeG["NnEt"]!.size)
        print("EnNt", screenSizeG["EnNt"]!.size)
        print("EnEt", screenSizeG["EnEt"]!.size)
        
        self.tabBarController?.tabBar.alpha = 0.f
        self.navigationController?.navigationBar.alpha = 0.f
        
        label.textColor = .black
        UIView.animate(withDuration: 0.8, animations: {
            self.label.textColor = .red
        }) { _ in
//            ログイン判定
            if NCMBUser.current() == nil {
                // ログインしていなかったら
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                self.present(rootViewController, animated: true, completion: nil)
            } else {
                // ログイン中だったら
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                self.present(rootViewController, animated: false, completion: nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
