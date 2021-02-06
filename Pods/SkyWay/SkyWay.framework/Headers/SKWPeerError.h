////////////////////////////////////////////////////////////////////////
// SKWPeerError.h
// SkyWay SDK
////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>
#import "SKWCommon.h"

/**
 * \file SKWPeerError.h
 */

//! Error type
typedef NS_ENUM(NSInteger, SKWPeerErrorEnum) {
    //! \~japanese エラーがない状態です。
    //! \~english No error.
    SKW_PEER_ERR_NO_ERROR = 0,
    //! \~japanese WebRTC の利用をサポートしていません。
    //! \~english The client's browser does not support some or all WebRTC features that you are trying to use.
    SKW_PEER_ERR_BROWSER_INCOMPATIBLE = -1,
    //! \~japanese 既に接続は切断されている状態です。
    //! \~english You've already disconnected this peer from the server and can no longer make any new connections on it.
    SKW_PEER_ERR_DISCONNECTED = -2,
    //! \~japanese Peer で指定した ID が無効です。
    //! \~english The ID passed into the Peer constructor contains illegal characters.
    SKW_PEER_ERR_INVALID_ID = -3,
    //! \~japanese  API キーが間違っています。
    //! \~english The API key passed into the Peer constructor contains illegal characters or is not in the system (cloud server only).
    SKW_PEER_ERR_INVALID_KEY = -4,
    //! \~japanese  シグナリングサーバとのネットワークエラーです。
    //! \~english Lost or cannot establish a connection to the signalling server.
    SKW_PEER_ERR_NETWORK = -5,
    //! \~japanese  接続できない Peer に接続しようとしています。
    //! \~english The peer you're trying to connect to does not exist.
    SKW_PEER_ERR_PEER_UNAVAILABLE = -6,
    //! \~japanese  SSL 関連のエラーです。
    //! \~english PeerJS is being used securely, but the cloud server does not support SSL. Use a custom PeerServer.
    SKW_PEER_ERR_SSL_UNAVAILABLE = -7,
    //! \~japanese  サーバに関連する何らかのエラーです。
    //! \~english Unable to reach the server.
    SKW_PEER_ERR_SERVER_ERROR = -8,
    //! \~japanese  ソケットレベルにおける何らかのエラーです。想定されるエラーは以下の通りです。 \n \n ・SkyWay のシグナリングサーバと接続ができません。\n ・SkyWay の dispatcher へのリクエストが失敗しました。ネットワーク接続を確認してください。\n ・SkyWay の dispatcher へのリクエストが中断されました。\n ・SkyWay の dispatcher へのリクエストがタイムアウトしました。ファイアウォールの設定やインターネット設定・SkyWay の障害情報を確認してください。\n ・SkyWay のシグナリングサーバーから予期せぬレスポンスを受け取りました。\n ・SkyWay のシグナリングサーバからドメインを含まない不正な JSON を受け取りました。\n  ・SkyWay のシグナリングサーバから不正な JSON を受け取りました。
    //! \~english socket error. Expected errors are as follows. \n \n ・Could not connect to server. \n ・There was a problem with the request for the dispatcher. Check your peer options and network connections. \n ・The request for the dispatcher was aborted. \n ・The request for the dispatcher timed out. Check your firewall, network speed, SkyWay failure information \n ・Connection failed. Unexpected response: ${http.status} \n ・The dispatcher server returned an invalid JSON response. have no signaling server domain in JSON. \n ・The dispatcher server returned an invalid JSON response.
    SKW_PEER_ERR_SOCKET_ERROR = -9,
    //! \~japanese  SkyWay のシグナリングサーバとの接続が失われました。
    //! \~english The underlying socket closed unexpectedly.
    SKW_PEER_ERR_SOCKET_CLOSED = -10,
    //! \~japanese  他で既に使っている ID を指定しているなどで、ID が指定できない場合のエラーです。
    //! \~english The ID passed into the Peer constructor is already taken.
    SKW_PEER_ERR_UNAVAILABLE_ID = -11,
    //! \~japanese ルームに関連する何らかのエラーです。想定されるエラーは以下の通りです。\n \n ・ルーム名が指定されていません。\n ・そのルーム名は別のタイプのルームで使用されています。他の名前で再度試してください。\n ・SFU 機能が該当の API キーで Disabled です。利用するには、Dashboard から enable にしてください。\n ・ルームへの入室中に不明なエラーが発生しました。少し待って、リトライしてください。\n ・ルームログ取得時に不明なエラーが発生しました。少し待って、リトライしてください。\n ・ルーム内のユーザー一覧の取得中に不明なエラーが発生しました。少し待って、リトライしてください。\n ・offer のリクエスト中に不明なエラーが発生しました。少し待って、リトライしてください。\n ・answer の処理中に不明なエラーが発生しました。少し待って、リトライしてください。\n ・SFU ルームは 1000 回までしか入室できません。
    //! \~english Room error. Expected errors are as follows. \n ・Room name must be defined. \n ・"${roomName}" is already used as different room type. Please try another room name. \n ・SFU room functionality is disabled for this apikey. \n ・An error occurred joining the room. Please wait a while and try again. \n ・An error occurred getting log messages. Please wait a while and try again. \n ・An error occurred getting users in the room. Please wait a while and try again. \n ・An error occurred requesting offer. Please wait a while and try again. \n ・An error occurred handling answer. Please wait a while and try again. \n ・A SFU room is only joined up to 1000 times.
    SKW_PEER_ERR_AUTHENTICATION = -12,
    //! \~japanese  WebRTC 関連での何らかのエラーです。
    //! \~english Failed to authenticate.
    SKW_PEER_ERR_WEBRTC = -20,
    //! \~japanese 指定されたクレデンシャルを用いた認証に失敗しました。想定されるエラーは以下の通りです。\n \n ・タイムスタンプを現在時刻より将来の時刻にすることはできません。\n ・クレデンシャルが期限切れになっています。\n ・認証トークンが期限切れになっています。\n ・認証トークンが不正です。\n ・TTL に制限よりも大きい数値が設定されています。\n ・TTL に制限よりも小さい数値が設定されています。
    //! \~english Failed to authenticate. Expected errors are as follows. \n \n ・"timestamp" can\'t be in the future. \n ・Credential has expired. \n ・"authToken" has already expired. \n ・"ttl" is too large. Max value is ${maxTTL}. \n ・"ttl" is too small. Min value is ${minTTL}. \n ・"authToken" is invalid.
    SKW_PEER_ERR_ROOM_ERROR = -30,
    //! \~japanese  シグナリング回数が Community Edition の無償利用枠を超過しているため、全ての機能が利用できません。（Community Edition のみ）
    //! \~english Signaling-Server is not available because the monthly Signaling-Server usage limit for Community Edition has been exceeded.
    SKW_PEER_ERR_SIGNALING_LIMITED = -40,
    //! \~japanese  SFU サーバ利用量が Community Edition の無償利用枠を超過しているため、SFU の機能が利用できません。（Community Edition のみ）
    //! \~english SFU is not available because the monthly SFU usage limit for Community Edition has been exceeded.
    SKW_PEER_ERR_SFU_LIMITED = -41,
    //! \~japanese  TURN サーバ利用量が Community Edition の無償利用枠を超過しているため、TURN の機能が利用できません。（Community Edition のみ）
    //! \~english TURN is not available because the monthly TURN usage limit for Community Edition has been exceeded.
    SKW_PEER_ERR_TURN_LIMITED = -42,
    //! \~japanese 不明なエラーです。
    //! \~english Unknown error.
    SKW_PEER_ERR_UNKNOWN = -9999,
};

//! \~japanese エラー情報クラス
//! \~english Error information class
//! \~
@interface SKWPeerError : NSObject <NSCopying>

//! \~japanese エラー種別文字列
//! \~english Error type string
//! \~
@property(nonatomic, readonly) NSString *typeString;

//! \~japanese エラーメッセージ
//! \~english Error message
//! \~
@property(nonatomic, readonly) NSString *message;

#ifndef DOXYGEN_SKIP_THIS
//! \~japanese
//! \~english Error type
//! \~
@property(nonatomic, readonly) SKWPeerErrorEnum type SKYWAY_API_DEPRECATED;

//! \~japanese
//! \~english NSError object
//! \~
@property(nonatomic, readonly) NSError *error SKYWAY_API_DEPRECATED;
#endif // !DOXYGEN_SKIP_THIS

@end
