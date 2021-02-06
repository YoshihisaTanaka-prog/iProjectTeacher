////////////////////////////////////////////////////////////////////////
// SKWRoomOption.h
// SkyWay SDK
////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

/**
 * \file SKWRoomOption.h
 */

@class SKWMediaStream;

//! \~japanese ルームモード
//! \~english Room mode
//! \~
typedef NS_ENUM(NSUInteger, SKWRoomModeEnum)
{
    //! \~japanese フルメッシュルーム
    //! \~english Fullmesh type room
    //! \~
    SKW_ROOM_MODE_MESH = 0,
    //! \~japanese SFU ルーム
    //! \~english SFU type room
    //! \~
    SKW_ROOM_MODE_SFU = 1,
};

//! \~japanese ルーム初期化オプションクラス
//! \~english Room Options
//! \~
@interface SKWRoomOption : NSObject < NSCopying >

//! \~japanese ルームモードを指定します
//! \~english Room Mode
//! \~
@property (nonatomic, assign) SKWRoomModeEnum mode;

//! \~japanese 送信するメディアストリームを指定します
//! \~english User's medias stream to send other participants.
//! \~
@property (nonatomic) SKWMediaStream* __nullable stream;

//! \~japanese 映像の最大バンド幅を kbps で指定します。
//! \~english A max video bandwidth(kbps)
//! \~
@property (nonatomic, assign) NSInteger videoBandwidth;

//! \~japanese 音声の最大バンド幅を kbps で指定します。
//! \~english A max audio bandwidth(kbps)
//! \~
@property (nonatomic, assign) NSInteger audioBandwidth;

//! \~japanese 映像コーデックを指定します。対応コーデックは端末機種により異なります。\n
//! 取りうる値は次のとおりです。'H264', 'VP8', 'VP9' メッシュ接続のみ使用可能です。
//! \~english Video Codec. The supported codecs are different depending on the device model.\n
//! The following values are possible. 'H264', 'VP8', 'VP9' Only available when mode is 'mesh'.
//! \~
@property (nonatomic, copy) NSString* __nullable videoCodec;

//! \~japanese 音声コーデックを指定します。対応コーデックは端末機種により異なります。\n
//! 取りうる値は次のとおりです。'opus', 'ISAC', 'G722', 'PCMU', 'PCMA' メッシュ接続のみ使用可能です。
//! \~english Audio Codec. The supported codecs are different depending on the device model.\n
//! The following values are possible. 'opus', 'ISAC', 'G722', 'PCMU', 'PCMA' Only available when mode is 'mesh'.
//! \~
@property (nonatomic, copy) NSString* __nullable audioCodec;

@end
