//
//  TransformateExtensions.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/06/04.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import Foundation
import UIKit



extension Int{
    public var d: Double {
        return Double(self)
    }
    public var f: CGFloat {
        return CGFloat(self)
    }
    public var s: String {
        return String(self)
    }
    public var s02: String {
        return String(format: "%02d", self)
    }
}

extension Double{
    public var i: Int {
        return Int(self)
    }
    public var f: CGFloat {
        return CGFloat(self)
    }
    public var s: String {
        return String(self)
    }
    public var s2: String {
        return String(format: "%.2f", self)
    }
}
extension String{
    public var ary: [String] {
        let cArray = Array(self)
        var ret: [String] = []
        for c in cArray {
            ret.append(String(c))
        }
        return ret
    }
    
    public var upHead: String{
        if self == ""{
            return self
        }
        let array = self.ary
        var ret = array[0].uppercased()
        
        if self.count != 1{
            for i in 1..<array.count{
                ret += array[i]
            }
        }
        
        return ret
    }
}

extension Date{
    public var ymd: String{
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .medium
        f.locale = Locale.current
        return f.string(from: self)
    }
    public var ymdJp: String{
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .long
        f.locale = Locale.current
        return f.string(from: self)
    }
    public var y: Int{
        let c = Calendar.current
        return c.component(.year, from: self)
    }
    public var m: Int{
        let c = Calendar.current
        return c.component(.month, from: self)
    }
    public var d: Int{
        let c = Calendar.current
        return c.component(.day, from: self)
    }
}
