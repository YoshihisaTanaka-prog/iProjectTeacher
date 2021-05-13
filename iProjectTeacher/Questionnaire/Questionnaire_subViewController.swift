//
//  QuestionnaireViewController.swift
//  iProjectStudent
//
//  Created by Ring Trap on 2/8/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class QuestionnaireViewController: UIViewController {

    var questionaire: Questionnaire!
    var timer: Timer!
    var collageName = ""
    var domain = ""
    /*
     let qustionlist = [[
     内向型or外交型の質問
     ],[
     もう一個の方の質問
     ]]
     という形式で入力お願いします。
     
     注意点として、isNegative -> isNormalに変更しました。（true,false の考え方が不自然だったから。）
     
     p.s. Opning2ViewController.swiftを弄ってテストしておいてください。
     
     */
    
    let qustionlist = [[
        QuestionInputFormat(question: "応用よりもまずは基礎をじっくり学びたい", isNormal: false),
        QuestionInputFormat(question: "初対面の人とも気さくに話せる", isNormal: false),
        QuestionInputFormat(question: "計画を立てるのが苦手", isNormal: false),
        QuestionInputFormat(question: "一人で過ごすのが好き", isNormal: true),
        QuestionInputFormat(question:"慎重だとよく言われる", isNormal: false),
        QuestionInputFormat(question: "ポジティブに考えることが多い", isNormal: true),
        QuestionInputFormat(question: "新しいアイデアをひらめくことが好きだ", isNormal: false),
        QuestionInputFormat(question: "周りから大人しいと言われる", isNormal: true),
        QuestionInputFormat(question: "論理的に相手を説得させることができる", isNormal: false),
        QuestionInputFormat(question: "積極的だとよく言われる", isNormal: true),
        QuestionInputFormat(question: "絵や図で説明してもらう方がわかりやすい", isNormal: false),
        QuestionInputFormat(question: "自分の話をするより人の話を聞くことが多い", isNormal: true)
    ]]

    override func viewDidLoad() {
        super.viewDidLoad()
        questionaire = Questionnaire(questions: qustionlist, onlyEven: 4)
        
        self.view.addSubview(questionaire.mainScrollView)
        
        self.setBackGround(false , false)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(QuestionnaireViewController.read), userInfo: nil, repeats: true)
        
//        ドメインがDBに存在しない時の管理サイトへの通知と大学の自動入力
//        まずは登録されたメールアドレスからドメインだけを抜き取り、許可されたドメインかどうか判定する。
        domain = NCMBUser.current()!.mailAddress.components(separatedBy: "@").last!.lowercased()
        let query1 = NCMBQuery(className: "Domain")
        query1?.whereKey("domain", equalTo: domain)  // ドメインを検索
        query1?.findObjectsInBackground({ (result, error) in
            if error == nil{
                if result!.count == 0 {
//                    ドメインが登録されていない場合
//                    管理サイトに通知する。
                    self.sendToRailsServer(message: "id=" + NCMBUser.current()!.objectId + "&domain=" + self.domain, path: "/app/user/domain")
//                    あとで一括自動入力ができるように一旦ドメイン名を大学名として仮登録する
                    self.collageName = self.domain
//                    ドメインを仮登録
                    let object = NCMBObject(className: "Domain")
                    object?.setObject(false, forKey: "checked")
                    object?.setObject(false, forKey: "parmitted")
                    object?.setObject(self.domain, forKey: "domain")
                    object?.setObject("", forKey: "collage")
                    object?.saveInBackground({ (error) in
                        if error != nil{
                            self.showOkAlert(title: "Error", message: error!.localizedDescription)
                        }
                    })
                } else{
                    let object = result!.first as! NCMBObject
                    let isChecked = object.object(forKey: "checked") as! Bool
                    if isChecked{
//                        登録済みのドメインの場合
                        let isPermitted = object.object(forKey: "parmitted") as! Bool
                        if isPermitted{
//                            大学のドメインの場合、大学名を取得する
                            self.collageName = object.object(forKey: "collage") as! String
                        } else{
//                            大学のドメインではない場合、管理サイトに通知する。
                            self.sendToRailsServer(message: "id=" + NCMBUser.current()!.objectId + "&domain=" + self.domain + "&banned=true", path: "/app/user/domain")
                        }
                    } else{
//                        登録はされているが確認されていないのドメインの場合、管理サイトに通知する。
                        self.sendToRailsServer(message: "id=" + NCMBUser.current()!.objectId + "&domain=" + self.domain, path: "/app/user/domain")
                    }
                }
            } else{
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        })
        
    }
    
    @objc func read(){
        if(questionaire.result > -1){
            timer.invalidate()
//            TeacherParameterの初期値入力をして画面を移動
            let object = NCMBObject(className: "TeacherParameter")
//            性格グループ
            object?.setObject(questionaire.result, forKey: "personalityGroup")
//            その他の初期値
            object?.setObject("", forKey: "choice")
            object?.setObject(collageName, forKey: "collage")
            object?.setObject("", forKey: "furigana")
            object?.setObject(0, forKey: "grade")
            object?.setObject("", forKey: "introduction")
            object?.setObject(false, forKey: "isAbleToTeach")
            object?.setObject(true, forKey: "isPermitted")
            object?.setObject("", forKey: "selection")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.setObject(NCMBUser.current()!.objectId, forKey: "userId")
            object?.setObject("", forKey: "userName")
            object?.setObject("FFFFFF", forKey: "youbi")
//            平均点の計算・検索用の初期値
            let subjectList = ["modernWriting","ancientWiting","chineseWriting","math1a","math2b","math3c","physics","chemistry","biology","earthScience",
                "geography","japaneseHistory","worldHistory","modernSociety","ethics","politicalScienceAndEconomics","English"]
            let scoreList = ["AverageScore","TotalScore","TotalNum"]
            for subject in subjectList{
                for score in scoreList{
                    object?.setObject(0, forKey: subject + score)
                }
                object?.setObject(false, forKey: "isAbleToTeach-" + subject)
            }
            object?.saveInBackground({ (error) in
                if(error == nil){
//                    ユーザクラス側の初期値
                    NCMBUser.current()?.setObject(object, forKey: "parameter")
                    NCMBUser.current()?.setObject(nil, forKey: "imageName")
                    NCMBUser.current()?.setObject(nil, forKey: "peerId")
                    NCMBUser.current()?.setObject(true, forKey: "isActive")
                    NCMBUser.current()?.setObject("", forKey: "name")
                    NCMBUser.current()?.signUpInBackground({ (error) in
                        if(error == nil){
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                            currentUserG = User(user!)
                            self.present(rootViewController, animated: false, completion: nil)
                        }
                        else{
                            self.showOkAlert(title: "Error", message: error!.localizedDescription)
                        }
                    })
                }
                else{
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
        }
        if(questionaire.result == -2){
            questionaire.result = -1
            showOkAlert(title: "注意", message: "未回答の項目があります。")
            questionaire.mainScrollView.setContentOffset(CGPoint(x: 0, y: -questionaire.mainScrollView.contentInset.top), animated: true)
        }
    }
}
