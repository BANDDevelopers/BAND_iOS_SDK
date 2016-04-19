//
//  UIImage+BDKSample.m
//  BDK Sample
//
//  Created by Alan on 2016. 2. 4..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "UIImage+BDKSample.h"


@implementation UIImage (BDKSample)

#pragma mark - Loading

+ (void)bdk_loadImageWithURL:(NSURL *)URL defaultImage:(UIImage *)defaultImage size:(CGSize)size completion:(void (^)(UIImage *image))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:URL]];
        
        if (!CGSizeEqualToSize(size, CGSizeZero)) {
            
            image = [image bdk_resizedImage:size];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BDK_RUN_BLOCK(completion, image ? : defaultImage);
        });
    });
}


#pragma mark - Resizing

- (instancetype)bdk_resizedImage:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    
    [self drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
