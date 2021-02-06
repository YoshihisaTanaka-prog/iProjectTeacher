//
//  MediaConnectionViewController.swift
//  swift
//
//

import UIKit
import NCMB
import SkyWay

class MediaConnectionViewController: UIViewController {

    fileprivate var peer: SKWPeer?
    fileprivate var mediaConnection: SKWMediaConnection?
    fileprivate var localStream: SKWMediaStream?
    fileprivate var remoteStream: SKWMediaStream?
    
    var userId: String!
    var size: Size!
    var isAudioOn = true
    var isCameraOn = true
    
    
    var mainView = UIView()
    var waitingLabel = UILabel()
    var localStreamView = SKWVideo()
    var remoteStreamView = SKWVideo()
    var endCallButton = UIButton()
    var audioButton = UIButton()
    var cameraButton = UIButton()
    var subview = UIView()
    var tabView = UIView()
    var whiteBoard = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        size = getScreenSize(isExsistsNavigationBar: false, isExsistsTabBar: false)
        print(userId!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.view.subviews.contains(mainView)){}
        self.setup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let query = NCMBUser.query()
            query?.whereKey("objectId", equalTo: self.userId)
            query?.findObjectsInBackground({ (result, error) in
                if(error == nil){
                    if(result!.count == 0){
                        self.showOkAlert(title: "Error", message: error!.localizedDescription + "\nUserId : " + self.userId)
                    }
                    else{
                        let user = result!.first as! NCMBUser
                        let peerId = user.object(forKey: "peerId") as? String
                        if(peerId == nil){
                            DispatchQueue.main.async {
                                self.mainView.addSubview(self.waitingLabel)
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                self.call(targetPeerId: peerId!)
                            }
                        }
                    }
                }
                else{
                    self.showOkAlert(title: "Error", message: error!.localizedDescription)
                }
            })
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mediaConnection?.close(true)
        self.peer?.destroy()
        NCMBUser.current()!.setObject(nil, forKey: "peerId")
        NCMBUser.current()!.saveInBackground { (error) in
            if(error != nil){
                self.showOkAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapCall(){
        guard let peer = self.peer else{
            return
        }
        
        Util.callPeerIDSelectDialog(peer: peer, myPeerId: peer.identity) { (peerId) in
            self.call(targetPeerId: peerId)
        }
    }

    @objc func tapEndCall(){
        
        let alertController = UIAlertController(title: "", message: "本当に退出しますか？", preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            self.mediaConnection?.close(true)
            self.changeConnectionStatusUI(connected: false)
        }
        let canselAction = UIAlertAction(title: "Cansel", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertOkAction)
        alertController.addAction(canselAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func tappedAudioButton(){
        if isAudioOn {
            isAudioOn = false
            audioButton.setTitle("マイクOFF", for: .normal)
        }
        else{
            isAudioOn =  true
            audioButton.setTitle("マイクON ", for: .normal)
        }
        let trackNum = localStream!.getAudioTracks()
        for i in 0..<trackNum {
            localStream?.setEnableAudioTrack(i, enable: isAudioOn)
        }
    }
    @objc func tappedVideoButton(){
        if isCameraOn {
            isCameraOn = false
            cameraButton.setTitle("カメラOFF", for: .normal)
        }
        else{
            isCameraOn = true
            cameraButton.setTitle("カメラON ", for: .normal)
        }
        let trackNum = localStream!.getVideoTracks()
        for i in 0..<trackNum{
            localStream?.setEnableVideoTrack(i, enable: isCameraOn)
        }
    }

    func changeConnectionStatusUI(connected:Bool){
        if connected {
            if(mainView.subviews.contains(waitingLabel)){
                waitingLabel.removeFromSuperview()
            }
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: setup skyway

extension MediaConnectionViewController{
    
    func setup(){
        
        let x = size.viewHeight - 10.f
        let y = size.width - 10.f
        
        mainView.frame = CGRect(x: 0, y: 0, width: x, height: y)
        mainView.center = CGPoint(x: size.width / 2.f, y: size.topMargin + size.viewHeight / 2.f)
        mainView.transform = mainView.transform.rotated(by: Double.pi.f / 2.f)
        
        waitingLabel.frame = CGRect(x: 0, y: 0, width: x, height: y)
        waitingLabel.text = "待機中"
        waitingLabel.textAlignment = .center
        waitingLabel.backgroundColor = .white
        waitingLabel.alpha = 0.5
        
        localStreamView.frame = CGRect(x: 0, y: 0, width: x / 3.f - 10.f, height: y / 3.f - 10.f)
        localStreamView.center = CGPoint(x: 5.f * x / 6.f, y: 2.f * y / 3.f)
        localStreamView.layer.borderColor = UIColor.black.cgColor
        localStreamView.layer.borderWidth = 1
        localStreamView.backgroundColor = .white
        
        remoteStreamView.frame = CGRect(x: 0, y: 0, width: x / 3.f - 10.f, height: y / 3.f - 10.f)
        remoteStreamView.center = CGPoint(x: 5.f * x / 6.f, y: y / 3.f)
        remoteStreamView.layer.borderColor = UIColor.black.cgColor
        remoteStreamView.layer.borderWidth = 1
        remoteStreamView.backgroundColor = .white
        
        endCallButton.frame = CGRect(x: 0, y: 0, width: x / 3.f - 10.f, height: y / 6.f - 10.f )
        endCallButton.center = CGPoint(x: 5 * x / 6.f, y: y / 12.f)
        endCallButton.setTitle("退出", for: .normal)
        endCallButton.setTitleColor(UIColor.white, for: .normal)
        endCallButton.backgroundColor = .red
        endCallButton.addTarget(self, action: #selector(self.tapEndCall), for: .touchUpInside)
        
        audioButton.frame = CGRect(x: 0, y: 0, width: x / 6.f - 10.f, height: y / 6.f - 10.f)
        audioButton.center = CGPoint(x: 3.f * x / 4.f, y: 11.f * y / 12.f)
        audioButton.setTitle("マイクOFF", for: .normal)
        audioButton.setTitleColor(UIColor.white, for: .normal)
        audioButton.backgroundColor = .blue
        audioButton.addTarget(self, action: #selector(self.tappedAudioButton), for: .touchUpInside)
        
        cameraButton.frame = CGRect(x: 0, y: 0, width: x / 6.f - 10.f, height: y / 6.f - 10.f)
        cameraButton.center = CGPoint(x: 11.f * x / 12.f, y: 11.f * y / 12.f)
        cameraButton.setTitle("カメラOff", for: .normal)
        cameraButton.setTitleColor(UIColor.white, for: .normal)
        cameraButton.backgroundColor = .blue
        cameraButton.addTarget(self, action: #selector(self.tappedVideoButton), for: .touchUpInside)
        
        whiteBoard.frame = CGRect(x: 0, y: 0, width: 2.f * x / 3.f - 10.f, height: 2.f * y / 3.f - 10.f)
        whiteBoard.center = CGPoint(x: x / 3.f, y: 7.f * y / 12.f )
        whiteBoard.backgroundColor = .white
        whiteBoard.layer.borderWidth = 1
        whiteBoard.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        whiteBoard.text = "ホワイトボード"
        whiteBoard.textAlignment = .center
        
        tabView.frame = CGRect(x: 0, y: 0, width: 2.f * x / 3.f - 10.f , height: y / 6.f - 10.f)
        tabView.center = CGPoint(x: x / 3.f, y: y / 6.f)
        tabView.layer.borderWidth = 1
        tabView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        self.view.addSubview(mainView)
        mainView.addSubview(whiteBoard)
        mainView.addSubview(tabView)
        mainView.addSubview(localStreamView)
        mainView.addSubview(remoteStreamView)
        mainView.addSubview(endCallButton)
        mainView.addSubview(cameraButton)
        mainView.addSubview(audioButton)
        
        guard let apikey = (UIApplication.shared.delegate as? AppDelegate)?.skywayAPIKey, let domain = (UIApplication.shared.delegate as? AppDelegate)?.skywayDomain else{
            print("Not set apikey or domain")
            return
        }
        
        let option: SKWPeerOption = SKWPeerOption.init();
        option.key = apikey
        option.domain = domain
        
        peer = SKWPeer(options: option)
        
        if let _peer = peer{
            self.setupPeerCallBacks(peer: _peer) // 自分のpeerを作成
            self.setupStream(peer: _peer)
        }else{
            print("failed to create peer setup")
        }
    }
    
    func setupStream(peer:SKWPeer){
        SKWNavigator.initialize(peer);
        let constraints:SKWMediaConstraints = SKWMediaConstraints()
        self.localStream = SKWNavigator.getUserMedia(constraints)
        self.localStream?.addVideoRenderer(self.localStreamView, track: 0)
    }
    
    func call(targetPeerId:String){
        let option = SKWCallOption()
        
        if let mediaConnection = self.peer?.call(withId: targetPeerId, stream: self.localStream, options: option){
            print("successed to call :\(targetPeerId)")
            self.mediaConnection = mediaConnection
            self.setupMediaConnectionCallbacks(mediaConnection: mediaConnection)
        }else{
            print("failed to call :\(targetPeerId)")
        }
    }
}

// MARK: skyway callbacks

extension MediaConnectionViewController{
    
    func setupPeerCallBacks(peer:SKWPeer){
        
        // MARK: PEER_EVENT_ERROR
        peer.on(SKWPeerEventEnum.PEER_EVENT_ERROR, callback:{ (obj) -> Void in
            if let error = obj as? SKWPeerError{
                print("\(error)")
            }
        })
        
        // MARK: PEER_EVENT_OPEN
        peer.on(SKWPeerEventEnum.PEER_EVENT_OPEN,callback:{ (obj) -> Void in
            if let peerId = obj as? String{
                DispatchQueue.main.async {
                    NCMBUser.current()!.setObject(peerId, forKey: "peerId")
                    NCMBUser.current()!.saveInBackground { (error) in
                        if(error != nil){
                            self.showOkAlert(title: "Error", message: error!.localizedDescription)
                        }
                    }
                }
                print("your peerId: \(peerId)")
            }
        })
        
        // MARK: PEER_EVENT_CONNECTION
        peer.on(SKWPeerEventEnum.PEER_EVENT_CALL, callback: { (obj) -> Void in
            if let connection = obj as? SKWMediaConnection{
                self.setupMediaConnectionCallbacks(mediaConnection: connection)
                self.mediaConnection = connection
                connection.answer(self.localStream)
            }
        })
    }
    
    func setupMediaConnectionCallbacks(mediaConnection:SKWMediaConnection){

        // MARK: MEDIACONNECTION_EVENT_STREAM
        mediaConnection.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_STREAM, callback: { (obj) -> Void in
            if let msStream = obj as? SKWMediaStream{
                self.remoteStream = msStream
                self.changeConnectionStatusUI(connected: true)
                DispatchQueue.main.async {
                    self.remoteStream?.addVideoRenderer(self.remoteStreamView, track: 0)
                }
            }
        })
        
        // MARK: MEDIACONNECTION_EVENT_CLOSE
        mediaConnection.on(SKWMediaConnectionEventEnum.MEDIACONNECTION_EVENT_CLOSE, callback: { (obj) -> Void in
            if let _ = obj as? SKWMediaConnection{
                DispatchQueue.main.async {
                    self.remoteStream?.removeVideoRenderer(self.remoteStreamView, track: 0)
                    self.remoteStream = nil
                    self.mediaConnection = nil
                }
                self.changeConnectionStatusUI(connected: false)
            }
        })
    }
}
