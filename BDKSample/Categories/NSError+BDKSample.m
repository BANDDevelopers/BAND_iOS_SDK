//
//  NSError+BDKSample.m
//  BDK Sample
//
//  Created by Alan on 2016. 3. 14..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "NSError+BDKSample.h"


static NSString *const BDKSampleErrorDomain = @"BDKSampleErrorDomain";


@implementation NSError (BDKSample)

+ (instancetype)bdk_nilParameterErrorWithParameterName:(NSString *)parameterName codeDescription:(const char *)codeDescription lineNumber:(int)lineNumber {
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    info[NSLocalizedDescriptionKey] = [[NSString alloc] initWithFormat:@"A not nilable parameter %@ is nil.", parameterName];
    info[NSLocalizedFailureReasonErrorKey] = [[NSString alloc] initWithFormat:@"%s\n(Line %d)", codeDescription, lineNumber];
    
    return [NSError errorWithDomain:BDKSampleErrorDomain code:-1 userInfo:[[NSDictionary alloc] initWithDictionary:info]];
}

@end
