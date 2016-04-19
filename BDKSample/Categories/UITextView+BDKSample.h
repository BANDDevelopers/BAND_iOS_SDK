//
//  UITextView+BDKSample.h
//  BDK Sample
//
//  Created by Alan on 2016. 3. 2..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UITextView (BDKSample)

- (BOOL)bdk_isPlaceholderSet;

- (void)bdk_setPlaceholder:(NSString *)placeholder;
- (void)bdk_setText:(NSString *)text;

@end
