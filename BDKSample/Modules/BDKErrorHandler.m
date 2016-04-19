//
//  BDKErrorHandler.m
//  BDK Sample
//
//  Created by Alan on 2016. 2. 25..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "BDKErrorHandler.h"

#import <BandSDK/BandSDK.h>

#import "UIAlertView+BDKSample.h"


@interface BDKErrorHandler () <UIAlertViewDelegate>

@property (assign, nonatomic) BDKErrorCode errorCodeCache;

@end


#pragma mark -

@implementation BDKErrorHandler

#pragma mark - Instantiation

+ (instancetype)handler {
    return [[self alloc] init];
}


#pragma mark - Control

- (void)handleError:(NSError *)error withCodeDescription:(const char *)codeDescription lineNumber:(int)lineNumber onViewController:(UIViewController *)viewController {
    [self setErrorCodeCache:error.code];
    
    switch ((BDKErrorCode)error.code) {
        case BDKErrorCodeAuth: {
            [BDKAPI logoutWithCompletion:^ {
                [viewController.navigationController popToRootViewControllerAnimated:NO];
                [UIAlertView bdk_showAlertWithLocalizedMessage:@"alert.error.auth.message"];
            }];
            break;
        }
        case BDKErrorCodeBandAppNotInstalled: {
            [UIAlertView bdk_showQueryWithLocalizedMessage:@"alert.error.bandAppNotInstalled.message" delegate:self];
            break;
        }
        default: {
            [UIAlertView bdk_showError:error withCodeDescription:codeDescription lineNumber:lineNumber];
            break;
        }
    }
}


#pragma mark - UIAlertViewController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (self.errorCodeCache) {
        case BDKErrorCodeBandAppNotInstalled: {
            [self bandAppNotInstalledErrorAlertView:alertView clickedButtonAtIndex:buttonIndex];
            break;
        }
        default: {
            break;
        }
    }
}


- (void)bandAppNotInstalledErrorAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1: {
            [BDKAPI installBandApp];
            break;
        }
        default: {
            break;
        }
    }
}

@end
