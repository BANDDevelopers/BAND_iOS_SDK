//
//  NSString+BDKSample.m
//  BDK Sample
//
//  Created by Alan on 2016. 2. 3..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "NSString+BDKSample.h"


@implementation NSString (BDKSample)

#pragma mark - Constant

+ (NSBundle *)bdk_enBundle {
    static dispatch_once_t onceToken;
    __strong static NSBundle *enBundle = nil;
    
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        enBundle = path ? [NSBundle bundleWithPath:path] : [NSBundle mainBundle];
    });
    
    return enBundle;
}


#pragma mark - Localization

- (instancetype)bdk_localizedString {
    NSString *defaultValue = [[[self class] bdk_enBundle] localizedStringForKey:self value:@"" table:nil];
    NSString *localizedValue = NSLocalizedStringWithDefaultValue(self, nil, [NSBundle mainBundle], defaultValue, nil);
    return localizedValue.length > 0 ? localizedValue : defaultValue;
}

@end
