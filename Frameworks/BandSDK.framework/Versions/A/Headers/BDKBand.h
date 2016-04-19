//
//  BDKBand.h
//  BandSDK
//
//  Created by JeongHoHong on 2016. 1. 20.
//  Copyright © 2016 Camp Mobile Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 *  This constant specifies the size of a Band cover image.
 */
typedef NS_ENUM(NSInteger, BDKBandCoverImageType) {
    /// 110 pixels square image.
    BDKBandCoverImageTypeSquare110,
    
    /// 312 x 212 pixel rectangle image.
    BDKBandCoverImageTypeAspectFill312,
    
    /// 640 x 480 pixel rectangle image.
    BDKBandCoverImageTypeAspectFill640,
};


/**
 *  This class represents the Band information.
 */
@interface BDKBand : NSObject <NSCopying, NSCoding>

/// Band ID.
@property (strong, nonatomic, readonly) NSString *bandKey;

/// Band name.
@property (strong, nonatomic, readonly) NSString *name;

/// URL of a Band cover image.
@property (strong, nonatomic, readonly) NSURL *coverImageURL;

/// The number of members joining the Band.
@property (strong, nonatomic, readonly) NSNumber *memberCount;

/// Whether it is a guild Band.
@property (assign, nonatomic, readonly, getter=isGuildBand) BOOL guildBand;


/**
 *  Returns the URL of a Band cover image of the specified type.
 *
 *  @param type Type of a Band cover image.
 *
 *  @see BDKBandCoverImageType
 */
- (NSURL *)coverImageURLWithType:(BDKBandCoverImageType)type;

@end
