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
    
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = dColor.opening
        
        self.tabBarController?.tabBar.alpha = 0.f
        self.navigationController?.navigationBar.alpha = 0.f
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        TabBarやNavigationBarがある時の画面サイズの取得
        let size = screenSizeG["NnNt"]!
        
        screenSizeG["NnEt"] = Size(tm: size.topMargin, bm: self.view.safeAreaInsets.bottom)
        screenSizeG["EnNt"] = Size(tm: self.view.safeAreaInsets.top, bm: size.bottomMargin)
        screenSizeG["EnEt"] = Size(tm: self.view.safeAreaInsets.top, bm: self.view.safeAreaInsets.bottom)
        print("NnEt", screenSizeG["NnEt"]!.viewHeight)
        print("EnNt", screenSizeG["EnNt"]!.viewHeight)
        print("EnEt", screenSizeG["EnEt"]!.viewHeight)
        
        label.textColor = .black
        UIView.animate(withDuration: 0.8, animations: {
            self.label.textColor = .red
        }) { _ in
            if isLogInG {
                // ログイン中だったら
//                let storyboard = UIStoryboard(name: "Questionnaire", bundle: Bundle.main)
//                let rootViewController = storyboard.instantiateViewController(withIdentifier: "QuestionnaireController")
//                let storyboard = UIStoryboard(name: "Student", bundle: Bundle.main)
//                let rootViewController = storyboard.instantiateViewController(identifier: "first")
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(identifier: "RootTabBarController") as! UITabBarController
                let nextNC = rootViewController.viewControllers!.first! as! UINavigationController
                let nextVC = nextNC.viewControllers.first!
                self.present(rootViewController, animated: true, completion: nil)
                myScheduleG.loadSchedule(date: Date(), userIds: [currentUserG.userId], nextVC)

            } else {
                // ログインしていなかったら
//                let storyboard = UIStoryboard(name: "Questionnaire", bundle: Bundle.main)
//                let rootViewController = storyboard.instantiateViewController(withIdentifier: "QuestionnaireController")
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                self.present(rootViewController, animated: true, completion: nil)
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
