//
//  CheckBox.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/18.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit

class CheckBox {
    var mainView: UIView
    var checkBoxes: [CheckBoxButton]
    var height = 5.f
    var width = 0.f
    
    init(_ list: [CheckBoxInput]) {
        self.mainView = UIView()
        checkBoxes = []
        for i in 0..<list.count {
            self.checkBoxes.append(CheckBoxButton(list[i], num: i, width: &width))
            self.mainView.addSubview(self.checkBoxes[i].button)
            self.mainView.addSubview(self.checkBoxes[i].label)
            height += 25.f
        }
        self.mainView.frame = CGRect(x: 0, y: 60, width: self.width, height: self.height)
        print(height)
    }
    
    public var selectionText: String{
        var ret = ""
        for c in checkBoxes {
            if c.isSelected {
                ret += "T"
            } else {
                ret += "F"
            }
        }
        return ret
    }
    
    func setSelection(_ selection: String) {
        if selection.count == checkBoxes.count {
            let array = selection.ary
            
            for i in 0..<array.count{
                let s = array[i]
                if(s == "T"){
                    checkBoxes[i].isSelected = true
                    checkBoxes[i].button.setTitle("◉", for: .normal)
                }
            }
        }
    }
    
    public var selectedKeys: [String] {
        var ret: [String] = []
        for c in checkBoxes {
            if c.isSelected {
                ret.append(c.key)
            }
        }
        return ret
    }
    
    func setSelectedKey(_ keyList: [String]) {
        for c in checkBoxes{
            if keyList.contains(c.key) {
                c.isSelected = true
                c.button.setTitle("◉", for: .normal)
            }
        }
    }
    
}

class CheckBoxButton {
    var button: UIButton
    var label: UILabel
    var key: String
    var isSelected = false
    
    init(_ c: CheckBoxInput, num: Int, width: inout CGFloat) {
        self.key = c.key
        self.label = UILabel()
        self.label.text = c.title
        self.label.textColor = c.color
        self.label.sizeToFit()
        let w = label.frame.width
        self.label.frame = CGRect(x: 35.f, y: 25.f * num.f, width: w, height: 20.f)
        if (width < w + 45.f) {
            width = w + 45.f
        }
        self.button = UIButton(frame: CGRect(x: 10.f, y: 25.f * num.f, width: 20.f, height: 20.f))
        self.button.setTitle("○", for: .normal)
        self.button.setTitleColor(UIColor(red: 0.f, green: 0.f, blue: 0.5.f, alpha: 1.f), for: .normal)
        self.button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc private func tapped(){
        if(self.isSelected){
            self.button.setTitle("○", for: .normal)
        }else{
            self.button.setTitle("◉", for: .normal)
        }
        self.isSelected = !self.isSelected
    }
}

class CheckBoxInput{
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
