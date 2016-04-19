//
//  UIAlertView+BDKSample.h
//  BDK Sample
//
//  Created by Alan on 2016. 2. 3..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@class BDKProfile, BDKQuota, BDKBand, BDKPost;


@interface UIAlertView (BDKSample)

+ (void)bdk_showAlertWithMessage:(NSString *)message;
+ (void)bdk_showAlertWithLocalizedMessage:(NSString *)localizedMessageKey;

+ (void)bdk_showQueryWithLocalizedMessage:(NSString *)localizedMessageKey delegate:(id<UIAlertViewDelegate>)delegate;

+ (void)bdk_showError:(NSError *)error withCodeDescription:(const char *)codeDescription lineNumber:(int)lineNumber;


+ (void)bdk_showAccessToken:(NSString *)accessToken;

+ (void)bdk_showProfile:(BDKProfile *)profile;
+ (void)bdk_showQuotas:(NSDictionary *)quotas;

+ (void)bdk_showGuildBandNameInputAlertWithCompletion:(void (^)(NSString *bandName))completion;

+ (void)bdk_showBand:(BDKBand *)band;
+ (void)bdk_showOfficialBandInformationWithBandKey:(NSString *)bandKey joined:(BOOL)joined;
+ (void)bdk_showPost:(BDKPost *)post;

+ (void)bdk_showResultWithTitle:(NSString *)title quota:(BDKQuota *)quota;

@end
