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
    let size: [CGFloat]
    var setted: String = ""
    init(_ size: [CGFloat]) {
        self.size = size
    }
}

extension UIViewController {
    func getScreenSize(isExsistsNavigationBar: Bool, isExsistsTabBar: Bool) {
        switch [isExsistsNavigationBar,isExsistsTabBar] {
        case [false,false]:
            return screenSizeG["NnNt"]!.size
        case [false,true]:
            return screenSizeG["NnEt"]!.size
        case [true,false]:
            return screenSizeG["EnNt"]!.size
        case [true,true]:
            return screenSizeG["EnEt"]!.size
        default:
            return [0.f, 0.f]
        }
    }
    
    public var defaultColor: UIColor{
        return UIColor(red: 1.f, green: 1.f, blue: 1.f, alpha: 1.f)
    }
}
