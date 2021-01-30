# iProjectTeacher

便利な関数(関数名：goToChat)を作りました。
使い方：
  goToChat() -> チャットルーム一覧に移動できます。
  goToChat(userId (String型) ) -> 入力したユーザId(ニフクラ上のもの)のユーザとのチャットルームに移動できます。
  goToChat( ChatGroupのId or OneOnOneChatのId (String型), isGroup (GroupかOneOnOne
  かの判定をするためのBool型変数) ) -> 指定したチャットルームに移動できます。
  
  

便利な関数(関数名：getScreenSize)を作りました。（2021-01/30）
本来ならviewDidApear以降でしか取得できない画面サイズをあらかじめ保存しておくことによって使うことができるようになります。
ただし、viewDidApearより前の段階ではNavigationBarやTabBarの存在確認ができないので引数で指定する必要があります。
