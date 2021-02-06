////////////////////////////////////////////////////////////////////////
// SKWPeerCredential.h
// SkyWay SDK
////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

/**
 * \file SKWPeerCredential.h
 */

//! \~japanese Peerを認証するためのクレデンシャル
//! \~english The credential used to authenticate peer.
//! \~
@interface SKWPeerCredential : NSObject

//! \~japanese 現在のUNIXタイムスタンプです。
//! \~english Current UNIX timestamp.
//! \~
@property (nonatomic) NSUInteger timestamp;

//! \~japanese Time to live(ttl)。タイムスタンプ + ttl の時間でクレデンシャルが失効します。ttlの取りうる値は600~90,000です。
//! \~english Time to live; The credential expires at timestamp + ttl. The range of possible values for ttl is 600 to 90,000.
//! \~
@property (nonatomic) NSUInteger ttl;

//! \~japanese HMACを利用して生成する認証用トークンです。
//! \~english Credential token calculated with HMAC.
//! \~
@property (nonatomic, copy) NSString* authToken;

@end
