////////////////////////////////////////////////////////////////////////
// SKWAnswerOption.h
// SkyWay SDK
////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

/**
 * \file SKWAnswerOption.h
 */

//! \~japanese SKWMediaConnection answer オプション
//! \~english SKWMediaConnection answer Option
//! \~
@interface SKWAnswerOption : NSObject < NSCopying >

//! \~japanese 映像の最大バンド幅を kbps で指定します。
//! \~english A max video bandwidth(kbps)
//! \~
@property (nonatomic) NSUInteger videoBandwidth;

//! \~japanese 音声の最大バンド幅を kbps で指定します。
//! \~english A max audio bandwidth(kbps)
//! \~
@property (nonatomic) NSUInteger audioBandwidth;

//! \~japanese 映像コーデックを指定します。対応コーデックは端末機種により異なります。\n
//! 取りうる値は次のとおりです。'H264', 'VP8', 'VP9'
//! \~english Video Codec. The supported codecs are different depending on the device model.\n
//! The following values are possible. 'H264', 'VP8', 'VP9'
//! \~
@property (nonatomic) NSString* __nullable videoCodec;

//! \~japanese 音声コーデックを指定します。対応コーデックは端末機種により異なります。\n
//! 取りうる値は次のとおりです。'opus', 'ISAC', 'G722', 'PCMU', 'PCMA'
//! \~english Audio Codec. The supported codecs are different depending on the device model.\n
//! The following values are possible. 'opus', 'ISAC', 'G722', 'PCMU', 'PCMA'
//! \~
@property (nonatomic) NSString* __nullable audioCodec;

@end
