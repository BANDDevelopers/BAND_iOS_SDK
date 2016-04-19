//
//  BDKSnippet.h
//  BandSDK
//
//  Created by Alan on 2016. 1. 25.
//  Copyright © 2016 Camp Mobile Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 *  This class represents the snippet included in the content or a chat message.
 */
@interface BDKSnippet : NSObject <NSCopying, NSCoding>

/// Title of a snippet.
@property (strong, nonatomic) NSString *title;

/// Content of a snippet.
@property (strong, nonatomic) NSString *text;

/// URL of an image attachment.
@property (strong, nonatomic) NSURL *imageURL;

/// Text appearing on the link area.
@property (strong, nonatomic) NSString *linkName;

/// Link that works with Android devices.
@property (strong, nonatomic) NSString *androidLink;

/// Link that works with iOS devices.
@property (strong, nonatomic) NSString *iOSLink;

@end
