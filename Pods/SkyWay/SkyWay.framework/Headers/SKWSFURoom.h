////////////////////////////////////////////////////////////////////////
// SKWSFURoom.h
// SkyWay SDK
////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>
#import "SKWRoom.h"

/**
 * \file SKWSFURoom.h
 */

@class SKWMediaStream;
@class SKWRoomOption;

//! \~japanese SFU ルームクラス
//! \~english SFU room class
//! \~
//!
//! \~japanese
//! SFU接続でのルームを提供するルームクラスです。
//! \~english
//! Class that manages SFU type room.
//! \~
@interface SKWSFURoom : SKWRoom

//! \~japanese ルームを退出し、ルーム内のすべてのユーザーとのコネクションをcloseします。
//! \~english Close PeerConnection and emit leave and close event.
//! \~
- (void)close;

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
//! SKWSFURoom* room;
//! SKWMediaStream* stream;
//!
//! [room replaceStream:stream];
//!
//! \endcode
//!
//! @param newStream
//! \~japanese 交換対象となる新しいMediaStream
//! \~english The stream to replace the old stream with.
//! \~
- (void)replaceStream:(SKWMediaStream* __nullable)newStream;

@end
