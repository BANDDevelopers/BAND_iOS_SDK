//
//  BDKPostPhoto.h
//  BandSDK
//
//  Created by JeongHoHong on 2016. 2. 1.
//  Copyright © 2016 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


/**
 *  This class represents an image attached to content.
 */
@interface BDKPostPhoto : NSObject <NSCopying, NSCoding>

/// ID of an image attachment.
@property (strong, nonatomic, readonly) NSString *photoKey;

/// URL of an image attachment.
@property (strong, nonatomic, readonly) NSURL *URL;

/// Attached date and time.
@property (strong, nonatomic, readonly) NSDate *createdAt;

/// The number of comments for the image attachment.
@property (strong, nonatomic, readonly) NSNumber *commentCount;

/// The number of emotions for the image attachment.
@property (strong, nonatomic, readonly) NSNumber *emotionCount;

/// The width and height of an image attachment.
@property (assign, nonatomic, readonly) CGSize size;

/// Whether the image is a video thumbnail.
@property (assign, nonatomic, readonly, getter=isVideoThumbnail) BOOL videoThumbnail;

@end
