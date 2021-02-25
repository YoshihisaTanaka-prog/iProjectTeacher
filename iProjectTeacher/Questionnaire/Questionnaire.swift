//
//  Questionnaire.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit
import NCMB

class Questionnaire {
    var mainScrollView = UIScrollView()
    var result: Int = -1
    private var numOfButton: Int!
    private var questionViews: [[QuestionView]] = []
    private var totalNumbers: [Int] = []
    private var contentsView = UIView()
    private var mainSVHeight = 0.f
    private var size: Size!
    private var answerButton: UIButton!
    
    init(questions: [[QuestionInputFormat]], onlyEven numOfButton: Int) {
        self.numOfButton = numOfButton
        size = screenSizeG["NnNt"]!
        self.mainScrollView.frame = CGRect(x: 0.f, y: size.topMargin, width: size.width, height: size.viewHeight)
        self.mainScrollView.backgroundColor = dColor.base
        mainSVHeight = 20.f // mainScrollViewの高さなどを設定するための変数
//        アンケートの一番上に表示する文章の設定
        let titleLabel = UILabel(frame: CGRect(x: 10.f, y: 10.f, width: size.width - 20.f, height: 0))
        titleLabel.numberOfLines = 0
        titleLabel.text = "アンケートに答えて下さい。\n\nこのアンケートの結果はより良い教師とマッチングできるようにするために使います。\n\n"
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        self.contentsView.addSubview(titleLabel)
        mainSVHeight += titleLabel.frame.size.height
        
//        質問の追加をする
        var qNum = 0
        for i in 0..<questions.count {
            questionViews.append([])
            self.totalNumbers.append(-1)
            for j in 0..<questions[i].count {
                qNum += 1
                questionViews[i].append(QuestionView(size, questions[i][j], numOfButton, qNum))
                let qv = questionViews[i][j].mainView
                let centerHight = mainSVHeight + qv.frame.size.height / 2.f
                qv.center = CGPoint(x: size.width / 2.f, y: centerHight)
                self.contentsView.addSubview(qv)
                mainSVHeight += qv.frame.size.height + 10.f
            }
        }
        
//        「アンケートに答える」ボタンの設定
        answerButton = UIButton(frame: CGRect(x: 0.f, y: mainSVHeight, width: size.width, height: 40))
        answerButton.setTitle("アンケートに答える", for: .normal)
        answerButton.addTarget(self, action: #selector(tappedAnswer), for: .touchUpInside)
        answerButton.backgroundColor = .darkGray
        self.contentsView.addSubview(answerButton)
        mainSVHeight += 50.f
        
        titleLabel.text = titleLabel.text! + "（全" + qNum.s + "問）"
//        スクロールビューの高さを指定
        self.contentsView.frame = CGRect(x: 0.f, y: 0.f, width: size.width, height: mainSVHeight)
        self.mainScrollView.addSubview(self.contentsView)
        self.mainScrollView.contentSize = CGSize(width: size.width, height: mainSVHeight)
        self.mainScrollView.setFontColor()
    }
    
    @objc func tappedAnswer(){
        if(isAnsweredAllQuestions()){
//            reslt に値を埋め込む
            var res = 0
            var keta = 1
                for i in 0..<self.totalNumbers.count {
                    self.totalNumbers[i] = 0
                    for j in 0..<questionViews[i].count {
                        self.totalNumbers[i] += questionViews[i][j].reslut
                    }
                    if(self.totalNumbers[i] > questionViews[i].count * ( self.numOfButton - 1 ) / 2){
                        res += keta
                    }
                    keta *= 2
                }
            self.result = res
        }
        else{
            self.result = -2
        }
    }
    
    private func isAnsweredAllQuestions() -> Bool {
        var ret = true
        for questViews in self.questionViews {
            for questView in questViews {
                if(questView.reslut == -1){
                    ret = false
                    questView.mainView.backgroundColor = .yellow
                }
            }
        }
        return ret
    }
}


class QuestionView{
    var mainView: UIView
    private var buttons: [UIButton] = []
    var isNormal: Bool
    var numOfButton: Int
    var reslut: Int = -1
    
    init(_ size: Size, _ question: QuestionInputFormat, _ numOfButton: Int, _ qNum: Int) {
        self.isNormal = question.isNnormal
        self.numOfButton = numOfButton
        
        self.mainView = UIView(frame: CGRect(x: 0.f, y: 0.f, width: size.width, height: 0))
        
//        質問文の設定
        let questionLabel = UILabel()
        questionLabel.frame = CGRect(x: 10.f, y: 10.f, width: size.width - 20.f, height: 0)
        questionLabel.numberOfLines = 0
        questionLabel.text = "Q" + qNum.s + ".\n" + question.question
        questionLabel.sizeToFit()
        let height = questionLabel.frame.size.height
        self.mainView.addSubview(questionLabel)
        
//        選択肢の設定
        let label1 = UILabel(frame: CGRect(x: 10, y: height + 40.f, width: 120.f, height: 30.f))
        let label2 = UILabel(frame: CGRect(x: size.width - 130, y: height + 40.f, width: 120.f, height: 30.f))
        label1.text = "そう思う"
        label1.backgroundColor = .lightGray
        label1.textAlignment = .center
        label2.text = "そうは思わない"
        label2.backgroundColor = .lightGray
        label2.textAlignment = .center
        
        self.mainView.addSubview(label1)
        self.mainView.addSubview(label2)
        for i in 0..<numOfButton {
            self.buttons.append(CheckRadioButton(frame: CGRect(x: 0.f, y: 0.f, width: 30.f, height: 30.f)))
            self.buttons[i].center = CGPoint(x: size.width / 2.f - 54.f + i.f * 36, y: height + 95.f)
            self.buttons[i].setTitle("○", for: .normal)
            self.buttons[i].setTitleColor(dColor.font, for: .normal)
            self.buttons[i].alpha = 0.9.f
            self.buttons[i].tag = i
            self.buttons[i].addTarget(self, action: #selector(self.selected(_:)), for: .touchUpInside)
            self.mainView.addSubview(buttons[i])
        }
        
//        質問フォームの高さを指定
        self.mainView.frame = CGRect(x: 0.f, y: 0.f, width: size.width, height: height + 120.f)
    }
    
    @objc func selected(_ sender: UIButton){
        self.mainView.backgroundColor = .clear
        for i in 0..<self.numOfButton {
            if(i == sender.tag){
                buttons[i].setTitle("◉", for: .normal)
                buttons[i].alpha = 1.f
                if(isNormal){
                    self.reslut = i
                }
                else{
                    self.reslut = self.numOfButton - 1 - i
                }
            }
            else{
                buttons[i].setTitle("○", for: .normal)
                buttons[i].alpha = 0.6.f
            }
        }
    }
}

class QuestionInputFormat{
    var question: String
    var isNnormal: Bool
    init( question: String, isNormal: Bool) {
        self.isNnormal = isNormal
        if( question.hasSuffix("？") ){
            self.question = question
        }
        else if(question.hasSuffix("?") || question.hasSuffix(".") || question.hasSuffix("。")){
            self.question = String(question.prefix(question.count - 1)) + "？"
        }
        else{
            self.question = question + "？"
        }
    }
}

