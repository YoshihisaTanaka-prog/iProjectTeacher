////////////////////////////////////////////////////////////////////////
// SKWMeshRoom.h
// SkyWay SDK
////////////////////////////////////////////////////////////////////////
#import "SKWRoom.h"

/**
 * \file SKWMeshRoom.h
 */

@class SKWMediaStream;

//! \~japanese メッシュ接続でのルームを提供するルームクラスです。
//! \~english Mesh room class
//! \~
//!
//! \~japanese
//! メッシュ接続でのルームを管理するクラスです。
//! \~english
//! Class that manages fullmesh type room.
//! \~
@interface SKWMeshRoom : SKWRoom

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
//! SKWMeshRoom* room;
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
