//
//  QuestionnaireViewController.swift
//  iProjectTeacher
//
//  Created by Ring Trap on 2/15/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

class QuestionnaireViewController: UIViewController {

    var questionaire: Questionnaire!
    
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
        
    }
    
    @IBAction func tappedSend(){
        if questionaire.result != -1 {
            let object = NCMBUser.current()?.object(forKey: "parameter") as! NCMBObject
            object.setObject(questionaire.result, forKey: "personalityGroup")
            object.saveInBackground { (error) in
                if(error == nil){
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    self.present(rootViewController, animated: false, completion: nil)
                }
                else{
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            }
        }
    }
    
}
