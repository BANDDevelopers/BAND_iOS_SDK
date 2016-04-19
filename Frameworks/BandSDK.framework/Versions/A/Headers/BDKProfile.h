//
//  BDKProfile.h
//  BandSDK
//
//  Created by Alan on 2016. 1. 25.
//  Copyright © 2016 Camp Mobile Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 *  This constant specifies the size of a user's profile image.
 */
typedef NS_ENUM(NSInteger, BDKProfileImageType) {
    /// 40 pixels square image.
    BDKProfileImageTypeSquare40,
    
    /// 75 pixels square image.
    BDKProfileImageTypeSquare75,
    
    /// 150 pixels square image.
    BDKProfileImageTypeSquare150,
};


/**
 *  This class abstracts the user's profile information.
 */
@interface BDKProfile : NSObject <NSCopying, NSCoding>

/// User ID.
@property (strong, nonatomic, readonly) NSString *userKey;

/// Band ID.
@property (strong, nonatomic, readonly) NSString *bandKey;

/// User name.
@property (strong, nonatomic, readonly) NSString *name;

/// URL of a profile image.
@property (strong, nonatomic, readonly) NSURL *profileImageURL;

/// Whether the user's BAND account is connected.
@property (assign, nonatomic, readonly, getter=isAppConnected) BOOL appConnected;

/// Whether to allow messages to be received.
@property (assign, nonatomic, readonly) BOOL allowsMessages;


/**
 *  Returns the URL of a profile image of the specified type.
 *
 *  @param type Type of a profile image.
 *
 *  @see BDKProfileImageType
 */
- (NSURL *)profileImageURLWithType:(BDKProfileImageType)type;

@end
