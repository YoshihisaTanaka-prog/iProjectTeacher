//
//  Extensions.swift
//  ChatTest
//
//  Created by 田中義久 on 2021/01/13.
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
}

extension UIViewController{
    func showOkAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertOkAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
