//
//  BDKErrorHandler.h
//  BDK Sample
//
//  Created by Alan on 2016. 2. 25..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


#define BDK_HANDLE_ERROR(HANDLER, ERROR, VIEW_CONTROLLER) [(HANDLER) handleError:(ERROR) withCodeDescription:__PRETTY_FUNCTION__ lineNumber:__LINE__ onViewController:(VIEW_CONTROLLER)]


@interface BDKErrorHandler : NSObject

+ (instancetype)handler;


- (void)handleError:(NSError *)error withCodeDescription:(const char *)codeDescription lineNumber:(int)lineNumber onViewController:(UIViewController *)viewController;

@end
