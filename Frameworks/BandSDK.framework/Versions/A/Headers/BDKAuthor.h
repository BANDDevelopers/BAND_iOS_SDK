//
//  BDKAuthor.h
//  BandSDK
//
//  Created by JeongHoHong on 2016. 2. 1.
//  Copyright © 2016 Camp Mobile Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 *  This class represents the author information.
 */
@interface BDKAuthor : NSObject <NSCopying, NSCoding>

/// Author's user ID.
@property (strong, nonatomic, readonly) NSString *userKey;

/// Author name.
@property (strong, nonatomic, readonly) NSString *name;

/// URL of an author's profile image.
@property (strong, nonatomic, readonly) NSURL *profileImageURL;

/// Description about the author.
@property (strong, nonatomic, readonly) NSString *memo;

@end