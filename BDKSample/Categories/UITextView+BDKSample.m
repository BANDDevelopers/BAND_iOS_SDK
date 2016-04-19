//
//  UITextView+BDKSample.m
//  BDK Sample
//
//  Created by Alan on 2016. 3. 2..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "UITextView+BDKSample.h"


static NSInteger const BDKTextViewPlaceholderTag = 5048;


@implementation UITextView (BDKSample)

- (BOOL)bdk_isPlaceholderSet {
    return self.tag == BDKTextViewPlaceholderTag;
}


- (void)bdk_setPlaceholder:(NSString *)placeholder {
    if (placeholder) {
        [self setTag:BDKTextViewPlaceholderTag];
        [self setTextColor:[UIColor grayColor]];
        [self setText:placeholder];
    } else {
        [self setTag:0];
        [self setTextColor:[UIColor blackColor]];
        [self setText:nil];
    }
}


- (void)bdk_setText:(NSString *)text {
    if ([self bdk_isPlaceholderSet]) {
        [self bdk_setPlaceholder:nil];
    }
    
    [self setText:text];
}

@end
