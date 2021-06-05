//
//  Radiobuttom.swift
//  iProjectTeacher
//
//  Created by Kaori Nakamura on 5/27/21.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit


class Radiobutton {
    var mainView: UIView
    var radioButtonButtons: [UIButton]
    var radioButtonLabels: [UILabel]
    var radioButtonKeys: [String]
    var selectedText: String?
    var selectedKey: String?
    
    var height = 5.f
    var width = 0.f
    
    init(_ list: [RadioButtonInput]) {
        self.mainView = UIView()
        radioButtonButtons = []
        radioButtonLabels = []
        radioButtonKeys = []
        for i in 0..<list.count {
            //Keyの設定
            radioButtonKeys.append(list[i].key)
            
            //ラベルの設定
            let label = UILabel()
            label.text = list[i].title
            label.textColor = list[i].color
            label.sizeToFit()
            let w = label.frame.width
            label.frame = CGRect(x: 35.f, y: height, width: w, height: 20.f)
            radioButtonLabels.append(label)
            if (width < w + 45) {
                width = w + 45
            }
            
            //ボタンの設定
            let button = UIButton(frame: CGRect(x: 10.f, y: height, width: 20.f, height: 20.f))
            button.setTitle("○", for: .normal)
            button.setTitleColor(UIColor(red: 0.f, green: 0.f, blue: 0.5.f, alpha: 1.f), for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
            
            radioButtonButtons.append(button)
            //addSubviewは，その前のViewに（）内のViewを追加する
            self.mainView.addSubview(button)
            self.mainView.addSubview(label)
            
            height += 25.f
        }
        self.mainView.frame = CGRect(x: 0, y: 60, width: 0, height: self.height)
        print(height)
    }
    
    convenience init(_ list: [RadioButtonInput], selectedText: String) {
        self.init(list)
        self.selectedText = selectedText
        
        for i in 0..<self.radioButtonKeys.count{
            if( selectedText == radioButtonLabels[i].text! ){
                radioButtonButtons[i].setTitle("●", for: .normal)
            }
        }
    }
    
    convenience init(_ list: [RadioButtonInput], selectedKey: String) {
        self.init(list)
        self.selectedKey = selectedKey
        
        for i in 0..<self.radioButtonKeys.count{
            if( selectedKey == radioButtonKeys[i] ){
                radioButtonButtons[i].setTitle("●", for: .normal)
            }
        }
    }
    
    @objc private func tapped(sender:UIButton){
        for i in 0..<radioButtonButtons.count {
            if i == sender.tag{
                radioButtonButtons[i].setTitle("◉", for: .normal)
                self.selectedText = radioButtonLabels[i].text
                self.selectedKey = radioButtonKeys[i]
                
            } else {
                radioButtonButtons[i].setTitle("○", for: .normal)
            }
        }
    }
}

class RadioButtonInput{
    var title: String
    var color: UIColor
    var key: String
    init(_ title: String, color: UIColor){
        self.title = title
        self.key = title
        self.color = color
    }
    
    init(_ title: String){
        self.title = title
        self.key = title
        self.color = dColor.font
    }
    
    init(_ title: String, color: UIColor, key: String){
        self.title = title
        self.key = key
        self.color = color
    }
    
    init(_ title: String, key: String){
        self.title = title
        self.key = key
        self.color = dColor.font
    }
}
