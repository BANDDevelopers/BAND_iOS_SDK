//
//  BDKQuota.h
//  BandSDK
//
//  Created by Alan on 2016. 1. 22.
//  Copyright © 2016 Camp Mobile Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


OBJC_EXTERN NSString *const BDKQuotaNamePost;
OBJC_EXTERN NSString *const BDKQuotaNameMessage;
OBJC_EXTERN NSString *const BDKQuotaNameInvitation;


/**
 *  This class stores the individual quota information.
 */
@interface BDKQuota : NSObject <NSCopying, NSCoding>

/// Total quota.
@property (assign, nonatomic, readonly) NSInteger total;

/// The number of times remaining before the rate limit.
@property (assign, nonatomic, readonly) NSInteger remained;

/// Expected expiration time.
@property (strong, nonatomic, readonly) NSDate *expirationDate;

@end
