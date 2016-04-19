//
//  NSError+BDKSample.h
//  BDK Sample
//
//  Created by Alan on 2016. 3. 14..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


#define BDK_NILL_PARAMETER_ERROR(PARAMETER) [NSError bdk_nilParameterErrorWithParameterName:(PARAMETER) codeDescription:__PRETTY_FUNCTION__ lineNumber:__LINE__]


@interface NSError (BDKSample)

+ (instancetype)bdk_nilParameterErrorWithParameterName:(NSString *)parameterName codeDescription:(const char *)codeDescription lineNumber:(int)lineNumber;

@end
