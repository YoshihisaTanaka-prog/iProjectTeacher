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
    
    private var baceView: UIView!
    private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = dColor.opening
        
        
        let x = screenSizeG["NnNt"]!.width
        let y = screenSizeG["NnNt"]!.screenHeight
        let length = min(x, 500.f)
        
        baceView = UIView(frame: CGRect(x: 0, y: 0, width: length*0.8.f, height: length*0.8.f) )
        baceView.center = CGPoint(x: x / 2.f, y: y / 2.f)
        baceView.layer.cornerRadius = length / 10.f
        baceView.clipsToBounds = true
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: length*1.6.f, height: length*0.8.f) )
        imageView.image = UIImage(named: "iconT.png")
        baceView.addSubview(imageView)
        
        self.view.addSubview(baceView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.alpha = 0.f
        self.navigationController?.navigationBar.alpha = 0.f
//        TabBarやNavigationBarがある時の画面サイズの取得
        let size = screenSizeG["NnNt"]!
        
        screenSizeG["NnEt"] = Size(tm: size.topMargin, bm: self.view.safeAreaInsets.bottom)
        screenSizeG["EnNt"] = Size(tm: self.view.safeAreaInsets.top, bm: size.bottomMargin)
        screenSizeG["EnEt"] = Size(tm: self.view.safeAreaInsets.top, bm: self.view.safeAreaInsets.bottom)
        print("NnEt", screenSizeG["NnEt"]!.viewHeight)
        print("EnNt", screenSizeG["EnNt"]!.viewHeight)
        print("EnEt", screenSizeG["EnEt"]!.viewHeight)
        
        UIView.animate(withDuration: 0.8, animations: {
            let x = screenSizeG["NnNt"]!.width
            let length = min(x, 500.f)
            self.imageView.center = CGPoint(x: 0, y: length*0.4.f)
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
