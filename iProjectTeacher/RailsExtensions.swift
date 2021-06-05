//
//  RailsExtensions.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/06/04.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func sendToRailsServer(message: String, path: String){
        print("https://telecture.herokuapp.com" + path)
        print(message)
        let url = URL(string: "https://telecture.herokuapp.com" + path)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ("token=" + token + "&" + message).data(using: .utf8)
        print(request)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                if let response = response as? HTTPURLResponse{
                    print("HTTP response >> " + response.statusCode.s )
                }
            } else{
                print("HTTP Request ERROR >> " + error!.localizedDescription)
            }
        }.resume()
    }
}
