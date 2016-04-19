//
//  UIImage+BDKSample.h
//  BDK Sample
//
//  Created by Alan on 2016. 2. 4..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (BDKSample)

+ (void)bdk_loadImageWithURL:(NSURL *)URL defaultImage:(UIImage *)defaultImage size:(CGSize)size completion:(void (^)(UIImage *image))completion;

- (instancetype)bdk_resizedImage:(CGSize)newSize;

@end
