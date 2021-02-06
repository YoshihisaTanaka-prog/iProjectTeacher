////////////////////////////////////////////////////////////////////////
// SKWMediaConnection.h
// SkyWay SDK
////////////////////////////////////////////////////////////////////////
#import "SKWConnection.h"

/**
 * \file SKWMediaConnection.h
 */

@class SKWMediaStream;
@class SKWAnswerOption;


//! \~japanese メディアコネクションイベントタイプ
//! \~english Media connection event type
//! \~
typedef NS_ENUM(NSUInteger, SKWMediaConnectionEventEnum)
{
    //! \~japanese リモートメディアストリームを追加された時のイベントです
    //! \~english Emitted when a remote peer adds a stream.
    //! \~
    SKW_MEDIACONNECTION_EVENT_STREAM,
    //! \~japanese リモートメディアストリームが削除された時のイベントです
    //! \~english Emitted when a remote peer remove a stream.
    //! \~
    SKW_MEDIACONNECTION_EVENT_REMOVE_STREAM,
    //! \~japanese メディアコネクションが閉じられた時のイベントです
    //! \~english Emitted when either you or the remote peer closes the media connection.
    //! \~
    SKW_MEDIACONNECTION_EVENT_CLOSE,
    //! \~japanese エラーが発生した時のイベントです
    //! \~english Errors on the media conenction are almost always fatal and will destroy the media connection.
    //! \~
    SKW_MEDIACONNECTION_EVENT_ERROR,
};

//! \~japanese メディアコネクションイベントコールバックシグネチャ
//! \~english Media Event Callback signature.
//! \~
typedef void (^SKWMediaConnectionEventCallback)(NSObject* __nullable arg);

//! \~japanese MediaConnection 相当のクラスです。
//! \~english Alternative class as MediaConnection
//! \~
//!
//! \~japanese
//! このオブジェクトを取得するには、SKWPeer の callWithId メソッドを使用するか、
//! SKW_PEER_EVENT_CALL イベント発生時に渡されるオブジェクトを使用してください。
//! \~english
//! \~
@interface SKWMediaConnection : SKWConnection

//! \~japanese
//! call イベントを受信した場合に、応答するためのコールバックにて与えられる
//! SKWMediaConnection にて answer を呼び出せます。
//!
//! 送信するメディアストリームは使用せず、応答します。
//! \~english
//! When receiving a call event on a peer, you can call .answer on the media connection
//! provided by the callback to accept the call.
//! \~
//!
//! \code{.m}
//! SKWPeer* peer;
//!
//! [peer on:SKW_PEER_EVENT_CALL callback:^(NSObject* obj) {
//!     [media answer];
//! }];
//! \endcode
- (void)answer;

//! \~japanese
//! call イベントを受信した場合に、応答するためのコールバックにて与えられる
//! SKWMediaConnection にて answer を呼び出せます。
//!
//! 送信するメディアストリームを指定して、応答します。
//! \~english
//! When receiving a call event on a peer, you can call .answer on the media connection
//! provided by the callback to accept the call.
//! \~
//!
//! \code{.m}
//! SKWPeer* peer;
//!
//! [SKWNavigator initialize:peer];
//!
//! SKWMediaConstraints* constraints = [[SKWMediaConstraints alloc] init];
//! SKWMediaStream* stream = [SKWNavigator getUserMedia:constraints];
//!
//! [peer on:SKW_PEER_EVENT_CALL callback:^(NSObject* obj) {
//!     SKWMediaConnection* media = (SKWMediaConnection *)obj;
//!     [media answer:stream];
//! }];
//! \endcode
//!
//! @param stream
//! \~japanese SKWNavigator の getUserMedia によって取得される SKWMediaStream を指定します。
//! \~english Video stream
//! \~
- (void)answer:(SKWMediaStream* __nullable)stream;

//! \~japanese
//! call イベントを受信した場合に、応答するためのコールバックにて与えられる
//! SKWMediaConnection にて answer をオプション付きで呼び出せます。
//!
//! 送信するメディアストリームとオプションを指定して、応答します。
//! \~english
//! When receiving a call event on a peer, you can call .answer on the media connection
//! provided by the callback to accept the call with options.
//! \~
//!
//! \code{.m}
//! SKWPeer* peer;
//!
//! [SKWNavigator initialize:peer];
//!
//! SKWMediaConstraints* constraints = [[SKWMediaConstraints alloc] init];
//! SKWMediaStream* stream = [SKWNavigator getUserMedia:constraints];
//!
//! [peer on:SKW_PEER_EVENT_CALL callback:^(NSObject* obj) {
//!     SKWMediaConnection* media = (SKWMediaConnection *)obj;
//!     SKWAnswerOption* options = [[SKWAnswerOption alloc] init];
//!     options.videoBandwidth = 768;
//!     options.audioBandwidth = 64;
//!     [media answer:stream options:options];
//! }];
//! \endcode
//!
//! @param stream
//! \~japanese SKWNavigator の getUserMedia によって取得される SKWMediaStream を指定します。
//! \~english Video stream
//! \~
//!
//! @param options
//! \~japanese 応答時のオプションを指定します。
//! \~english Answer Options
//! \~
- (void)answer:(SKWMediaStream* __nullable)stream options:(SKWAnswerOption* __nullable)options;

//! \~japanese SKWMediaConnection を閉じます。forceClose オプションを NO として実行します。将来のバージョンから YES に変更される可能性があります。
//! \~english Closes the media connection. Run the forceClose option as NO. May be changed to YES from a future version.
//! \~
//!
//! \code{.m}
//! SKWMediaConnection* media;
//!
//! [media close];
//! media = nil;
//! \endcode
- (void)close;

//! \~japanese forceClose オプションを指定して、 SKWMediaConnection を閉じます。
//! \~english Closes the media connection with the forceClose option.
//! \~
//!
//! \code{.m}
//! SKWMediaConnection* media;
//!
//! [media close:YES];
//! media = nil;
//! \endcode
//!
//! @param forceClose
//! \~japanese この値がYESの場合、相手の MediaConnection も即座に close します。NOの場合、相手は ice 再接続が失敗してから MediaConnection を close します。
//! \~english Set to YES and the connection on remote peer will close immediately. When set to NO, the connection on remote peer will close after the end of the ICE reconnect by the browser.
//! \~
- (void)close:(BOOL)forceClose;

//! \~japanese SKWMediaConnection のイベントコールバック Block を設定します。
//! \~english Set callbacks for media connection events. (Block Literal Syntax)
//! \~
//!
//! \code{.m}
//! SKWMediaConnection* media;
//!
//! [media on:SKW_MEDIACONNECTION_EVENT_STREAM callback:^(NSObject* obj) {
//!     SKWMediaStream *stream = (SKWMediaStream *)obj;
//! }];
//!
//! [media on:SKW_MEDIACONNECTION_EVENT_REMOVE_STREAM callback:^(NSObject* obj) {
//!     SKWMediaStream *stream = (SKWMediaStream *)obj;
//! }];
//!
//! [media on:SKW_MEDIACONNECTION_EVENT_CLOSE callback:^(NSObject* obj) {
//!     // クローズ時の処理を記述
//! }];
//!
//! [media on:SKW_MEDIACONNECTION_EVENT_ERROR callback:^(NSObject* obj) {
//!     SKWPeerError* err = (SKWPeerError*)obj;
//!     NSLog(@"%@", err);
//! }];
//! \endcode
//!
//!  @param event
//! \~japanese 設定するイベント種別を指定します。
//! \~english Event type
//! \~
//!
//! @param callback
//! \~japanese イベント発生時に実行する Block を設定します。
//! \~english Callback block literal
//! \~
- (void)on:(SKWMediaConnectionEventEnum)event callback:(SKWMediaConnectionEventCallback __nullable)callback;

//! \~japanese
//! 送信中のMediaStreamを変更します。カメラデバイスや画質の変更などに用います。\n\n
//! 注意）MediaStreamを送信しない状態から送信する状態に変更することはできません。その逆の変更もできません。\n
//! 　　　また、「映像か音声のどちらかのみを持つMediaStream」と「映像・音声の両方を持つMediaStream」を入れ替えることはできません。
//! \~english Change the MediaStream that is being sent. For example, you can use it to change the camera device or the image quality.\n\n
//! Note: It is not possible to change the state of a MediaStream from not sending to sending.You cannot change the state of MediaStream from not sending to sending and vice versa.\n
//!       It is also not possible to interchange "MediaStream with either video or audio only" and "MediaStream with both video and audio".
//! \~
//!
//! \code{.m}
//! SKWMediaConnection* connection;
//! SKWMediaStream* stream;
//!
//! [connection replaceStream:stream];
//!
//! \endcode
//!
//! @param newStream
//! \~japanese 対向のピアに送るメディアストリーム
//! \~english
//! \~
- (void)replaceStream:(SKWMediaStream* __nullable)newStream;

@end
