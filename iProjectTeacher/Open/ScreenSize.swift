//
//  ExtensionForScreenSize.swift
//  opening
//
//  Created by 田中義久 on 2021/01/30.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit

var screenSizeG: Dictionary<String, Size> = [:]
class Size{
    let width: CGFloat
    let screenHeight: CGFloat
    let viewHeight: CGFloat
    let topMargin: CGFloat
    let bottomMargin: CGFloat
    
    init(x: CGFloat, y: CGFloat, tm: CGFloat, bm: CGFloat) {
        self.width = x
        self.screenHeight = y
        self.topMargin = tm
        self.bottomMargin = bm
        self.viewHeight = y - tm - bm
    }
    
    init(tm: CGFloat, bm: CGFloat) {
        let size = screenSizeG["NnNt"]!
        self.width = size.width
        self.screenHeight = size.screenHeight
        self.viewHeight = self.screenHeight - tm - bm
        self.topMargin = tm
        self.bottomMargin = bm
    }
}

extension UIViewController {
    func getScreenSize(isExsistsNavigationBar: Bool, isExsistsTabBar: Bool) -> Size? {
        switch [isExsistsNavigationBar,isExsistsTabBar] {
        case [false,false]:
            return screenSizeG["NnNt"]
        case [false,true]:
            return screenSizeG["NnEt"]
        case [true,false]:
            return screenSizeG["EnNt"]
        case [true,true]:
            return screenSizeG["EnEt"]
        default:
            return nil
        }
    }
    
    public var defaultColor: UIColor{
        return UIColor(red: 1.f, green: 1.f, blue: 1.f, alpha: 1.f)
    }
}
