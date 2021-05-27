//
//  EventViewController.swift
//  iProjectTeacher
//
//  Created by Ryusei Hiraoka on 2021/02/10.
//  Copyright © 2021 Tanaka_Yoshihisa_4413. All rights reserved.
//
import UIKit
import RealmSwift
import NCMB
import FSCalendar
import CalculateCalendarLogic

class EventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var sentDate: Date!
    private var date: String!
    private var selectedTime: Int?
    
    @IBOutlet private var calenderButton: UIButton!
    private var isFirstCalender = true
    private var calenderWhiteView: UIView!
    private var calenderView: FSCalendar!
    private var calenderTableView: UITableView!
    private var timeScheduleList: [TimeScaduleInput] = []
    private var currentMonth: Int!
    
    
    
    //スケジュール内容入力テキスト
    @IBOutlet private var eventText: UITextView!
    //日付フォーム(UIDatePickerを使用)
//    @IBOutlet private var y: UIDatePicker!
    //日付表示
    @IBOutlet private var y_text: UILabel!
    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var studentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventText.text = ""
        eventText.layer.borderWidth = 1.f
        eventText.layer.borderColor = UIColor.black.cgColor
        eventText.layer.cornerRadius = 10.f
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        y_text.text = ""
        date = formatter.string(from: sentDate)
        calenderButton.setTitle( date, for: .normal)
        setBackGround(false, false)
        
        let tmpCalendar = Calendar(identifier: .gregorian)
        currentMonth = tmpCalendar.component(.month, from: sentDate)
        
        for i in 0..<24{
            if(i%5 == 3){
                timeScheduleList.append(TimeScaduleInput(i, ""))
            }else if(i%5 == 2){
                timeScheduleList.append(TimeScaduleInput(i, "selected"))
            } else{
                timeScheduleList.append(TimeScaduleInput(i, "favorite"))
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let _ = checkDate(sentDate)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
//    教科用の　ク ラ ス 内 変数・定数
    private var selectedSubject = ""
    private var selectedSubjectList = [["------",""]]
    private let mainSubjectList = [["教科を選択",""],["国語",""],["数学",""],["理科",""],["社会",""],["英語","English"]]
    private let subSubjectList = [
        [["------",""]],
        [["詳細を選択",""],["現代文","modernWriting"],["古文","ancientWiting"],["漢文","chineseWriting"]],
        [["詳細を選択",""],["数学Ⅰ・A","math1a"],["数学Ⅱ・B","math2b"],["数学Ⅲ・C","math3c"]],
        [["詳細を選択",""],["物理","physics"],["化学","chemistry"],["生物","biology"],["地学","earthScience"]],
        [["詳細を選択",""],["地理","geography"],["日本史","japaneseHistory"],["世界史","worldHistory"],
         ["現代社会","modernSociety"],["倫理","ethics"],["政治・経済","politicalScienceAndEconomics"]],
        [["-----","English"]]
    ]
    
//    以下の関数たちは 同 じ 引 数 のものを探して 置 き 換 え て ください。
//    各ピッカービューの各縦部分の個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return mainSubjectList.count
        case 1:
            return selectedSubjectList.count
        default:
            return 0
        }
    }
    
//    ピッカービューに表示する内容を指定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return mainSubjectList[row][0]
        case 1:
            return selectedSubjectList[row][0]
        default:
            return ""
        }
    }
    
//    ピッカービューが選ばれた時の処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedSubjectList = subSubjectList[row]
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            selectedSubject = mainSubjectList[row][1]
            print(selectedSubject)
        case 1:
            selectedSubject = selectedSubjectList[row][1]
            print(selectedSubject)
        default:
            break
        }
    }
}


// 日付指定
extension EventViewController: UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    func checkDate(_ date: Date) -> Bool {
        let elapsedDays = Calendar.current.dateComponents([.day], from: Date(), to: date).day!
        if(elapsedDays < 2){
            showOkAlert(title: "注意", message: "この日程は予約不可能な日程です。\n日程を選び直してください。\n選択可能なのは3日後以降です。" ,okAction: {
                self.selectDate()
            })
            return false
        }
        return true
    }
    
    @IBAction func selectDate(){
        if isFirstCalender{
            isFirstCalender = false
            let size = getScreenSize(isExsistsNavigationBar: true, isExsistsTabBar: true)!
            
//            タップされた時に出てくるメインビュー
            calenderWhiteView = UIView( frame: CGRect(x: 0, y: 0, width: size.width, height: size.viewHeight ) )
            calenderWhiteView.center = CGPoint(x: size.width/2.f, y: size.topMargin + size.viewHeight/2.f)
            calenderWhiteView.backgroundColor = UIColor(red: 1.f, green: 1.f, blue: 1.f, alpha: 1.f)
            
//            カレンダーの表示
            let width = min( size.width*0.8.f, size.viewHeight/2.f - 10.f  )
            calenderView = FSCalendar( frame: CGRect(x: 0, y: 0, width: width, height: width) )
            calenderView.center = CGPoint( x: size.width/2.f, y: width/2.f )
            calenderView.setToJapanise()
            calenderView.select(sentDate)
            calenderView.dataSource = self
            calenderView.delegate = self
            calenderWhiteView.addSubview(calenderView)
            
//            テーブルビューの表示
            calenderTableView = UITableView( frame: CGRect(x: 0, y: width + 10.f, width: size.width, height: size.viewHeight - width - 20.f) )
            calenderTableView.dataSource = self
            calenderTableView.delegate = self
            calenderTableView.tableFooterView = UIView()
            calenderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            calenderWhiteView.addSubview(calenderTableView)
        }
        self.view.addSubview(calenderWhiteView)
    }
    
//    テーブルビューのセルの個数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let elapsedDays = Calendar.current.dateComponents([.day], from: Date(), to: sentDate).day!
        if(elapsedDays < 2){
            return 0
        }
        return timeScheduleList.count + 1
    }
    
//    テーブルビューの各セルに各内容を指定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        if( indexPath.row == timeScheduleList.count ){
            cell.textLabel?.text = "キャンセル"
            cell.textLabel?.textColor = UIColor(red: 1.f, green: 0.f, blue: 0.f, alpha: 1.f)
            cell.textLabel?.textAlignment = .center
        } else{
            cell.textLabel?.text = timeScheduleList[indexPath.row].timeText
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = timeScheduleList[indexPath.row].statusColor
        }
        return cell
    }
    
//    セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if( indexPath.row == timeScheduleList.count ){
            calenderWhiteView.removeFromSuperview()
        }  else{
            let st = indexPath.row
            let stt = timeScheduleList[indexPath.row].timeText
            switch timeScheduleList[indexPath.row].status {
            case "selected":
                showOkAlert(title: "注意", message: "予定が重複しています！\nこの時間帯には入力できません。")
            case "favorite":
                calenderWhiteView.removeFromSuperview()
                selectTime(st, stt)
            case "onlyTeacherFavorite":
                showOKCancelAlert(st, stt, "生徒")
            case "onlyStuderntFavorite":
                showOKCancelAlert(st, stt, "あなた")
            default:
                showOKCancelAlert(st, stt, nil)
            }
        }
        calenderTableView.reloadData()
    }
    
    private func showOKCancelAlert(_ st: Int, _ stt: String, _ role: String?){
        var msg = ""
        if role == nil{
            msg = "この時間帯はお気に入りの時間帯ではありません。\n本当にこの時間帯で大丈夫ですか？"
        } else{
            msg = "この時間帯は" + role! + "のお気に入りの時間帯ではありません。\n本当にこの時間帯で大丈夫ですか？"
        }
        
        let alertController = UIAlertController(title: "注意", message: msg, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            self.selectTime(st, stt)
        }
        let alertCancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertOkAction)
        alertController.addAction(alertCancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func selectTime(_ st: Int, _ stt: String){
        self.selectedTime = st
        self.calenderWhiteView.removeFromSuperview()
        self.y_text.text = stt
    }
    
    
//    ここからカレンダー
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
        let tmpCalendar = Calendar(identifier: .gregorian)
        let inputMonth = tmpCalendar.component(.month, from: date)
        if(inputMonth == currentMonth){
            //祝日判定をする
            if self.judgeHoliday(date){
                return UIColor(iRed: 255, iGreen: 0, iBlue: 0)
            }
            
            //土日の判定
            let weekday = self.getWeekIdx(date)
            if weekday == 1 {
                return UIColor(iRed: 255, iGreen: 0, iBlue: 0)
            }
            else if weekday == 7 {
                return UIColor(iRed: 0, iGreen: 0, iBlue: 255)
            }
            else{
                return dColor.font
            }
        }
        else{
            //祝日判定をする
            if self.judgeHoliday(date){
                return UIColor(iRed: 255, iGreen: 127, iBlue: 127)
            }
            
            //土日の判定
            let weekday = self.getWeekIdx(date)
            if weekday == 1 {
                return UIColor(iRed: 255, iGreen: 127, iBlue: 127)
            }
            else if weekday == 7 {
                return UIColor(iRed: 127, iGreen: 192, iBlue: 255)
            }
            else{
                return nil
            }
        }
    }
    
    //カレンダーで日付を選択された時の処理(スケジュール表示処理)
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let inputMonth = tmpCalendar.component(.month, from: date)
        if(currentMonth != inputMonth){
            calenderView.setCurrentPage(date, animated: true)
        }
        sentDate = date
        let _ = checkDate(sentDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        self.date = formatter.string(from: sentDate)
        calenderButton.setTitle(self.date, for: .normal)
        calenderTableView.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let tmpCalendar = Calendar(identifier: .gregorian)
        currentMonth = tmpCalendar.component(.month, from: calendar.currentPage)
        calenderView.reloadData()
    }
    
}

extension EventViewController{
    //DB書き込み処理
    @IBAction func saveEvent(_ : UIButton){
        if(selectedSubject == ""){
            showOkAlert(title: "注意", message: "教科を選択してください。")
            pickerView.backgroundColor = .yellow
        }
        else if(eventText.text.count == 0){
            showOkAlert(title: "注意", message: "イベントを入力してください。")
            eventText.backgroundColor = .yellow
        }
        else{
            print("データ書き込み開始")
            
            let realm = try! Realm()
            
            try! realm.write {
                //日付表示の内容とスケジュール入力の内容が書き込まれる。
                let Events = [Event(value: ["date": y_text.text, "event": studentLabel.text! + "(" + selectedSubject + ")" + eventText.text])]
                realm.add(Events)
                print("データ書き込み中")
            }
            
            print("データ書き込み完了")
            
            
            
            let object = NCMBObject(className:"ScheduleTeacher")
            object?.setObject(NCMBUser.current().objectId,forKey:"teacherId")
            object?.setObject(selectedSubject, forKey:"subject" )
            object?.setObject(y_text.text, forKey: "whenDo")
            object?.setObject(eventText.text, forKey: "whatToDo")
            object?.saveInBackground({ (error) in
                if(error == nil){
                    //前のページに戻る
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
            
        }
    }
    
}

