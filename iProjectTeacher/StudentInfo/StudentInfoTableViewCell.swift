//
//  StudentInfoTableViewCell.swift
//  iProjectTeacher
//
//  Created by 田中義久 on 2021/02/11.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import NCMB

protocol StudentInfoTableViewCellDelegate {
    func tappedSchedule()
    func tappedChat()
    func tappedChangeStatus()
}

class StudentInfoTableViewCell: UITableViewCell {
    
    var delegate: StudentInfoTableViewCellDelegate?
    var vc: UIViewController!
    var student: User!
    private var size: Size!
    private var follow: NCMBObject!
    private var scheduleButton: UIButton!
    private var chatButton: UIButton!
    private var centerButton: UIButton!
    private var leftButton: UIButton!
    private var rightButton: UIButton!
    
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var highSchool: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBOutlet var userNameFuriganaLabel: UILabel!
    @IBOutlet weak var firstChoiceLabel: UILabel!
    @IBOutlet weak var secondChoiceLabel: UILabel!
    @IBOutlet weak var thirdChoiceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        size = screenSizeG["NnNt"]!
        userimage.layer.cornerRadius = userimage.frame.width / 2.f
        userimage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setButtons(){
        let query = NCMBQuery(className: "Follow")
        query?.whereKey("fromUserId", equalTo: currentUserG.userId)
        query?.whereKey("toUserId", equalTo: student.userId)
        query?.findObjectsInBackground({ result, error in
            if(error == nil){
                self.follow = (result!.first as! NCMBObject)
            } else {
                self.vc.showOkAlert(title: "Searching follow deta error", message: error!.localizedDescription)
            }
        })
        let v = UIView(frame: CGRect(x: 0.f, y: 0.f, width: 258.f, height: 120.f))
        v.center = CGPoint(x: size.width / 2.f, y: 382.f)
        switch student.status{
        case 0:
            centerButton = UIButton(frame: CGRect(x: 69.f, y: 45.f, width: 120.f, height: 30.f))
            centerButton.setTitle("この生徒を登録", for: .normal)
            centerButton.addTarget(self, action: #selector(tappedRegistration), for: .touchUpInside)
            v.addSubview(centerButton)
        case 1:
            leftButton = UIButton(frame: CGRect(x: 6.f, y: 25.f, width: 120.f, height: 30.f))
            leftButton.setTitle("固定の生徒", for: .normal)
            leftButton.addTarget(self, action: #selector(tappedFavorite), for: .touchUpInside)
            v.addSubview(leftButton)
            rightButton = UIButton(frame: CGRect(x: 132.f, y: 25.f, width: 120.f, height: 30.f))
            rightButton.setTitle("ブロック", for: .normal)
            rightButton.addTarget(self, action: #selector(tappedBlock), for: .touchUpInside)
            v.addSubview(rightButton)
        case 2:
            leftButton = UIButton(frame: CGRect(x: 6.f, y: 25.f, width: 120.f, height: 30.f))
            leftButton.setTitle("固定を解除", for: .normal)
            leftButton.addTarget(self, action: #selector(tappedRegistration), for: .touchUpInside)
            v.addSubview(leftButton)
            rightButton = UIButton(frame: CGRect(x: 132.f, y: 25.f, width: 120.f, height: 30.f))
            rightButton.setTitle("ブロック", for: .normal)
            rightButton.addTarget(self, action: #selector(tappedBlock), for: .touchUpInside)
            v.addSubview(rightButton)
        default:
            break
        }
        
        if student.status != 0{
//            スケジュール行きのボタンを追加
            scheduleButton = UIButton(frame: CGRect(x: 6.f, y: 65.f, width: 120.f, height: 30.f))
            scheduleButton.setTitle("スケジュールへ", for: .normal)
            scheduleButton.addTarget(self, action: #selector(tappedSchedule), for: .touchUpInside)
            v.addSubview(scheduleButton)
//            チャット行きのボタンを追加
            chatButton = UIButton(frame: CGRect(x: 132.f, y: 65.f, width: 120.f, height: 30.f))
            chatButton.setTitle("チャットへ", for: .normal)
            chatButton.addTarget(self, action: #selector(tappedChat), for: .touchUpInside)
            v.addSubview(chatButton)
        }
        
        self.contentView.addSubview(v)
    }
    
    @objc func tappedSchedule(){
        self.delegate?.tappedSchedule()
    }
    @objc func tappedChat(){
        self.delegate?.tappedChat()
    }
    
    
    @objc func tappedRegistration(){
        changeStatus(status: 1)
    }
    @objc func tappedBlock(){
        changeStatus(status: -1)
    }
    @objc func tappedFavorite(){
        changeStatus(status: 2)
    }
    
    private func changeStatus(status: Int){
//        簡単に配列からユーザーを削除するための関数
        func remove(value: User, array: inout [User]) {
            var index: Int?
            for j in 0..<array.count{
                if array[j].userId == value.userId{
                    index = j
                    break
                }
            }
            if let i = index{
                array.remove(at: i)
            }
        }
//        NCMB上のデータをアップデート
        follow.setObject(status, forKey: "status")
        follow.saveInBackground { error in
            if error == nil{
//                元のステータスの配列から生徒を削除し、ボタンも削除
                switch self.student.status {
                case 0:
                    self.centerButton.removeFromSuperview()
                    remove(value: self.student, array: &waitingUserListG)
                case 1:
                    self.leftButton.removeFromSuperview()
                    self.rightButton.removeFromSuperview()
                    self.scheduleButton.removeFromSuperview()
                    self.chatButton.removeFromSuperview()
                    remove(value: self.student, array: &followUserListG)
                case 2:
                    self.leftButton.removeFromSuperview()
                    self.rightButton.removeFromSuperview()
                    self.scheduleButton.removeFromSuperview()
                    self.chatButton.removeFromSuperview()
                    remove(value: self.student, array: &favoriteUserListG)
                default:
                    break
                }
                self.student.status = status
//                新しいステータスの配列に生徒を追加
                switch self.student.status {
                case -1:
                    blockedUserIdListG.append(self.student.userId)
                case 1:
                    followUserListG.append(self.student)
                case 2:
                    favoriteUserListG.append(self.student)
                default:
                    break
                }
                self.delegate?.tappedChangeStatus()
            } else{
                self.vc.showOkAlert(title: "Changing status Error", message: error!.localizedDescription)
            }
        }
    }
}
