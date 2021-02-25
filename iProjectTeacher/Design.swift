//
//  Color.swift
//  iProjectStudent
//
//  Created by 田中義久 on 2021/02/19.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit


//    Color
class OriginalCollor {
    let concept: UIColor
    let base: UIColor
    let opening: UIColor
    let font: UIColor
    let accent: UIColor
    init() {
        self.concept = UIColor(iRed: 55, iGreen: 120, iBlue: 255)
        self.base = UIColor(iRed: 196, iGreen: 220, iBlue: 255)
        self.opening = UIColor(iRed: 122, iGreen: 170, iBlue: 255)
        self.font = UIColor(iRed: 0, iGreen: 0, iBlue: 50)
        self.accent = UIColor(iRed: 255, iGreen: 255, iBlue: 50)
    }
}

extension UIColor {
    convenience init(iRed: Int, iGreen: Int, iBlue: Int, iAlpha: Int){
        let r = iRed.f / 255.f
        let g = iGreen.f / 255.f
        let b = iBlue.f / 255.f
        let a = iAlpha.f / 255.f
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    convenience init(iRed: Int, iGreen: Int, iBlue: Int){
        let r = iRed.f / 255.f
        let g = iGreen.f / 255.f
        let b = iBlue.f / 255.f
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}


//BackGroundView
class BackGrounvView{
    var backView =  UIView()
    
    init(_ isExistsNavigationBar: Bool, _ isExistsTabBar: Bool, mainView: inout UIView){
        var title = ""
        switch [isExistsNavigationBar,isExistsTabBar] {
        case [false,false]:
            title = "NnNt"
        case [true ,false]:
            title = "EnNt"
        case [false,true ]:
            title = "NnEt"
        default:
            title = "EnEt"
        }
        
        let sizeInfo = screenSizeG[title]!
        let frame = CGRect(x: 0.f, y: sizeInfo.topMargin, width: sizeInfo.width, height: sizeInfo.viewHeight)
        let bigFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height)
        self.backView = UIView(frame: bigFrame)
        self.backView.backgroundColor = dColor.base
        mainView.addSubview(self.backView)
        mainView.sendSubviewToBack(self.backView)
    }
}

class AccentButton: UIButton {}
class AccentLabel: UILabel {}
class CategoryLabel: UILabel {}

class WeakButton: UIButton {}
class CheckRadioButton: UIButton {}

class PickerLabel: UILabel {
    convenience init(text: String, _ width: CGFloat) {
        self.init()
        self.frame = CGRect(x: 0.f, y: 0.f, width: width, height: 30)
        self.backgroundColor = dColor.base
        self.textColor = dColor.font
        self.textAlignment = .center
        self.text = text
    }
}

class IgnoreView: UIView {}

extension UIViewController{
    func setBackGround(_ isExistsNavigationBar: Bool, _ isExistsTabBar: Bool) {
        let _ = BackGrounvView(isExistsNavigationBar, isExistsTabBar, mainView: &self.view)
        self.view.setFontColor()
        
        let size = getScreenSize(isExsistsNavigationBar: false, isExsistsTabBar: false)!
        if isExistsNavigationBar {
            self.navigationController!.navigationBar.barTintColor = dColor.concept
            self.navigationController!.navigationBar.tintColor = dColor.font
        }
        else{
            let safeAreaView = UIView(frame: CGRect(x: 0.f, y: 0.f, width: size.width, height: size.topMargin))
            safeAreaView.backgroundColor = dColor.base
            self.view.addSubview(safeAreaView)
            self.view.sendSubviewToBack(safeAreaView)
        }
        if isExistsTabBar {
            self.tabBarController!.tabBar.barTintColor = dColor.concept
            self.tabBarController!.tabBar.tintColor = dColor.font
            self.tabBarController!.tabBar.unselectedItemTintColor = dColor.base
        }
        else{
            let safeAreaView = UIView(frame: CGRect(x: 0.f, y: size.viewHeight + size.topMargin, width: size.width, height: size.bottomMargin))
            safeAreaView.backgroundColor = dColor.base
            self.view.addSubview(safeAreaView)
            self.view.sendSubviewToBack(safeAreaView)
        }
    }
}

extension UIView{
    
    func setFontColor() {
        for view in self.subviews {
            if !(view is IgnoreView){
                view.setFontColor()
            }
            if view is UILabel{
                let v = view as! UILabel
                v.textColor = dColor.font
                v.backgroundColor = .clear
            }
            if view is CategoryLabel{
                let v = view as! CategoryLabel
                v.textColor = dColor.concept
            }
            if view is AccentLabel {
                let v = view as! AccentLabel
                v.backgroundColor = .clear
                let h = v.frame.size.height
                let w = v.frame.size.width
                let sv = IgnoreView(frame: CGRect(x: -12.f , y: h - 6.f, width: w + 24.f, height: 12.f))
                let lv = UILabel(frame: CGRect(x: 0.f, y:0.f, width: w, height: h))
                lv.text = v.text
                lv.backgroundColor = .clear
                lv.textAlignment = v.textAlignment
                v.text = ""
                sv.backgroundColor = dColor.accent
                sv.layer.cornerRadius = 6.f
                v.addSubview(sv)
                v.sendSubviewToBack(sv)
                v.addSubview(lv)
            }
//            if view is UIPickerView {
//                let v = view as! UIPickerView
//                v.backgroundColor = dColor.opening
//            }
            if view is UITextField{
                let v = view as! UITextField
                v.textColor = dColor.font
                v.backgroundColor = .clear
            }
            if view is UITextView{
                let v = view as! UITextView
                v.textColor = dColor.font
                v.backgroundColor = .clear
            }
            if view is UIButton {
                let v = view as! UIButton
                v.setTitleColor(UIColor(iRed: 255, iGreen: 255, iBlue: 255), for: .normal)
                v.backgroundColor = dColor.concept
                let h = min( v.frame.size.height / 2.f , 15.f )
                v.layer.cornerRadius = h
            }
            if view is AccentButton {
                let v = view as! AccentButton
                v.setTitleColor(UIColor(iRed: 127, iGreen: 0, iBlue: 0), for: .normal)
                v.backgroundColor = dColor.accent
                let h = min( v.frame.size.height / 2.f , 15.f )
                v.layer.cornerRadius = h
            }
            if view is WeakButton {
                let v = view as! WeakButton
                v.setTitleColor(.blue, for: .normal)
                v.backgroundColor = .clear
            }
            if view is CheckRadioButton {
                let v = view as! CheckRadioButton
                v.setTitleColor(dColor.font, for: .normal)
                v.backgroundColor = .clear
            }
            if view is UITableView{
                let v = view as! UITableView
                v.backgroundColor = .clear
            }
        }
    }
    
}
