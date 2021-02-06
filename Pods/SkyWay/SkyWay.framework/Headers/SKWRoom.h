////////////////////////////////////////////////////////////////////////
// SKWRoom.h
// SkyWay SDK
////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

/**
 * \file SKWRoom.h
 */

@class SKWMediaStream;

//! \~japanese ルームイベント
//! \~english Room events
//! \~
typedef NS_ENUM(NSUInteger, SKWRoomEventEnum)
{
    //! \~japanese 現在のルームに新しいメディアストリームが追加された時のイベントです
    //! \~english MediaStream received from peer in the room.
    //! \~
    SKW_ROOM_EVENT_STREAM, // arg = added stream
    //! \~japanese 現在のルームから既存のメディアストリームが削除された時のイベントです
    //! \~english MediaStream removed from peer in the room.
    //! \~
    SKW_ROOM_EVENT_REMOVE_STREAM, // arg = removed stream
    //! \~japanese ルームに自分が入室した時のイベントです
    //! \~english Room is ready.
    //! \~
    SKW_ROOM_EVENT_OPEN, // arg = room name
    //! \~japanese  現在のルームから自分が退室した時、および SFU サーバーから切断されたとき時のイベントです
    //! \~english Fired when the Peer left the room, or the connection with the SFU server was disconnected.
    //! \~
    SKW_ROOM_EVENT_CLOSE, // arg = room name
    //! \~japanese 現在のルームにリモートピアが入室した時のイベントです
    //! \~english New peer has joined.
    //! \~
    SKW_ROOM_EVENT_PEER_JOIN, // arg = src
    //! \~japanese 現在のルームからリモートピアが退室した時のイベントです
    //! \~english A peer has left.
    //! \~
    SKW_ROOM_EVENT_PEER_LEAVE, // arg = src
    //! \~japanese エラーが発生した時のイベントです
    //! \~english Error occured.
    //! \~
    SKW_ROOM_EVENT_ERROR,
    //! \~japanese 現在のルームにリモートピアがらデータが送信された時のイベントです
    //! \~english Data received from peer.
    //! \~
    SKW_ROOM_EVENT_DATA, // arg = msg
    //! \~japanese 現在のルームのログが取得できた時のイベントです
    //! \~english Room's log received.
    //! \~
    SKW_ROOM_EVENT_LOG, // arg = logs
};

//! \~japanese ルームイベントコールバックシグネチャ
//! \~english Room Event Callback signature.
//! \~
typedef void (^SKWRoomEventCallback)(NSObject* __nullable arg);

//! \~japanese SKWMeshRoom / SKWSFURoom の基底クラスです。
//! \~english Room base class.
//! \~
@interface SKWRoom : NSObject

//! \~japanese ルーム名
//! \~english Room name.
//! \~
@property (nonatomic, readonly) NSString* __nullable name;

#ifndef DOXYGEN_SKIP_THIS
- (__nullable instancetype)init __attribute__((unavailable("init is not a supported initializer for this class.")));
#endif // !DOXYGEN_SKIP_THIS

//! \~japanese 現在のルームに入室中のピアにデータを送信します。NSString* または NSData* を送信できます。送信するデータサイズの上限は20MBです。送信頻度は100msecに1回に制限されています。送信頻度の制限を超えた送信データはキューに入り、100msec毎に順次送信されます。
//! \~english Send data to all participants in the room with WebSocket. It emits broadcast event. The max size of data that can be sent is 20MB. The frequent of consecutive send is limited to once every 100 msec. Outgoing data that exceeds the sending frequency limit is queued and sent sequentially every 100 msec.
//! \~
//!
//! \code{.m}
//! SKWRoom* room;
//! [room send:@"Hello."];
//! \endcode
//!
//! @param data
//! \~japanese 送信データ
//! \~english Send data
//! \~
//! @return
//! \~japanese 呼び出し結果
//! \~english Result.
//! \~
- (BOOL)send:(NSObject* __nonnull)data;

//! \~japanese SKWRoom のイベントコールバック block を設定します。
//! \~english Set blocks for SKWRoom events.
//! \~
//!
//! \code{.m}
//! SKWRoom* room;
//!
//! [room on:SKW_ROOM_EVENT_STREAM callback:^(NSObject* obj) {
//!     SKWMediaStream* stream = (SKWMediaStream*)obj;
//! }];
//!
//! [room on:SKW_ROOM_EVENT_REMOVE_STREAM callback:^(NSObject* obj) {
//!     SKWMediaStream* stream = (SKWMediaStream*)obj;
//! }];
//!
//! [room on:SKW_ROOM_EVENT_OPEN callback:^(NSObject* obj) {
//!     NSString* roomName = (NSString*)obj;
//! }];
//!
//! [room on:SKW_ROOM_EVENT_CLOSE callback:^(NSObject* obj) {
//!     NSString* roomName = (NSString*)obj;
//! }];
//!
//! [room on:SKW_ROOM_EVENT_PEER_JOIN callback:^(NSObject* obj) {
//!     NSString* peerId = (NSString*)obj;
//! }];
//!
//! [room on:SKW_ROOM_EVENT_PEER_LEAVE callback:^(NSObject* obj) {
//!     NSString* peerId = (NSString*)obj;
//! }];
//!
//! [room on:SKW_ROOM_EVENT_ERROR callback:^(NSObject* obj) {
//!     SKWPeerError* error = (SKWPeerError*)obj;
//! }];
//!
//! [room on:SKW_ROOM_EVENT_DATA callback:^(NSObject* obj) {
//!     SKWRoomDataMessage* msg = (SKWRoomDataMessage*)obj;
//!     NSString* peerId = msg.src;
//!     if ([msg.data isKindOfClass:[NSString class]]) {
//!         NSString* data = (NSString*)msg.data;
//!     }
//!     else if ([msg.data isKindOfClass:[NSData class]]) {
//!         NSData* data = (NSData*)msg.data;
//!     }
//! }];
//!
//! [room on:SKW_ROOM_EVENT_LOG callback:^(NSObject* obj) {
//!     NSArray* logs = (NSArray*)obj;
//! }];
//! \endcode
//!
//! @param event
//! \~japanese 設定するイベント種別を指定します。
//! \~english Event type
//! \~
//! @param callback
//! \~japanese イベント発生時に実行する Block を設定します。
//! \~english Callback block literal
//! \~
- (void)on:(SKWRoomEventEnum)event callback:(SKWRoomEventCallback __nullable)callback;

//! \~japanese SKWRoom の設定済みイベントコールバック block を解除します。
//! \~english Cancels the set event callback block of SKWRoom.
//! \~
//!
//! \code{.m}
//! SKWRoom* room;
//! [room offAll];
//! \endcode
- (void)offAll;

//! \~japanese シグナリングサーバにルームのログ取得を要求します。結果は SKW_ROOM_EVENT_LOG イベントで返されます。
//! \~english Start getting room's logs from signaling server. The result is returned in the SKW_ROOM_EVENT_LOG event.
//! \~
//!
//! \code{.m}
//! SKWRoom* room;
//!
//! [room on:SKW_ROOM_EVENT_LOG callback:^(NSObject* obj) {
//!     NSArray* logs = (NSArray*)obj;
//!     [logs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
//!         NSString* logStr = (NSString*)obj;
//!         NSError* error = nil;
//!         id logData = [NSJSONSerialization JSONObjectWithData:[logStr dataUsingEncoding:NSUTF8StringEncoding]
//!                                                      options:0
//!                                                        error:&error];
//!         if (nil == error)
//!         {
//!             NSLog(@"SKW_ROOM_EVENT_LOG: %@", logData);
//!         }
//!     }];
//! }];
//!
//! [room getLog];
//! \endcode
- (void)getLog;

@end
