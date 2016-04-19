//
//  BDKPost.h
//  BandSDK
//
//  Created by JeongHoHong on 2016. 2. 1.
//  Copyright © 2016 Camp Mobile Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


@class BDKAuthor;


/**
 *  This class abstracts content uploaded in the Band. 
 */
@interface BDKPost : NSObject <NSCopying, NSCoding>

/// Post ID.
@property (nonatomic, strong, readonly) NSString *postKey;

/// Post content.
@property (nonatomic, strong, readonly) NSString *content;

/// Image attachments.
@property (nonatomic, strong, readonly) NSArray /* <BDKPostPhoto> */ *photos;

/// Author.
@property (nonatomic, strong, readonly) BDKAuthor *author;

/// Published date and time.
@property (nonatomic, strong, readonly) NSDate *createdAt;

/// The number of comments.
@property (nonatomic, strong, readonly) NSNumber *commentCount;

/// Whether the multilingual support is provided.
@property (nonatomic, assign, readonly, getter=isMultilingual) BOOL multilingual;

@end