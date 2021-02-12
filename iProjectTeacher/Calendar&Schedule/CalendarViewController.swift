//
//  CalendarViewController.swift
//  iProjectTeacher
//
//  Created by Ryusei Hiraoka on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
     //スケジュール内容
    @IBOutlet var labelDate: UILabel!
        //「主なスケジュール」の表示
    @IBOutlet var labelTitle: UILabel!
        //カレンダー部分
   
        //日付の表示
    @IBOutlet var  Date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @objc func onClick(){ let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let SecondController = storyboard.instantiateViewController(withIdentifier: "Insert")
        present(SecondController, animated: true, completion: nil)
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
       fileprivate lazy var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter
       }()

       // 祝日判定を行い結果を返すメソッド
       func judgeHoliday(_ date : Date) -> Bool {
           //祝日判定用のカレンダークラスのインスタンス
           let tmpCalendar = Calendar(identifier: .gregorian)

           // 祝日判定を行う日にちの年、月、日を取得
           let year = tmpCalendar.component(.year, from: date)
           let month = tmpCalendar.component(.month, from: date)
           let day = tmpCalendar.component(.day, from: date)

           let holiday = CalculateCalendarLogic()

           return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
       }

       // date型 -> 年月日をIntで取得
       func getDay(_ date:Date) -> (Int,Int,Int){
           let tmpCalendar = Calendar(identifier: .gregorian)
           let year = tmpCalendar.component(.year, from: date)
           let month = tmpCalendar.component(.month, from: date)
           let day = tmpCalendar.component(.day, from: date)
           return (year,month,day)
       }

       //曜日判定
       func getWeekIdx(_ date: Date) -> Int{
           let tmpCalendar = Calendar(identifier: .gregorian)
           return tmpCalendar.component(.weekday, from: date)
       }

       // 土日や祝日の日の文字色を変える
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
           //祝日判定をする
           if self.judgeHoliday(date){
               return UIColor.red
           }

           //土日の判定
           let weekday = self.getWeekIdx(date)
           if weekday == 1 {
               return UIColor.red
           }
           else if weekday == 7 {
               return UIColor.blue
           }

           return nil
       }
    //カレンダー処理(スケジュール表示処理)
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){

            //予定がある場合、スケジュールをDBから取得・表示する。
            //無い場合、「スケジュールはありません」と表示。
            labelDate.text = "スケジュールはありません"
            labelDate.textColor = .lightGray
            view.addSubview(labelDate)

            let tmpDate = Calendar(identifier: .gregorian)
            let year = tmpDate.component(.year, from: date)
            let month = tmpDate.component(.month, from: date)
            let day = tmpDate.component(.day, from: date)
            let m = String(format: "%02d", month)
            let d = String(format: "%02d", day)

            let da = "\(year)/\(m)/\(d)"

            //クリックしたら、日付が表示される。
            Date.text = "\(m)/\(d)"
            view.addSubview(Date)

            //スケジュール取得
            let realm = try! Realm()
            var result = realm.objects(Event.self)
            result = result.filter("date = '\(da)'")
            print(result)
            for ev in result {
                if ev.date == da {
                    labelDate.text = ev.event
                    labelDate.textColor = .black
                    view.addSubview(labelDate)
                }
            }



        }
   }
  


