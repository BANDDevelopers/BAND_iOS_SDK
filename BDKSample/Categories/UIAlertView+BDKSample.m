//
//  UIAlertView+BDKSample.m
//  BDK Sample
//
//  Created by Alan on 2016. 2. 3..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import "UIAlertView+BDKSample.h"

#import <BandSDK/BandSDK.h>

#import "NSString+BDKSample.h"
#import "UIImage+BDKSample.h"


@interface BDKInputAlertViewDelegateImpl : NSObject <UIAlertViewDelegate>

@property (weak, nonatomic) UITextField *inputField;

@property (copy, nonatomic) void (^completion)(NSString *text);


+ (instancetype)sharedInstance;

@end


#pragma mark -

@implementation UIAlertView (BDKSample)

+ (void)bdk_showAlertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showAlertWithLocalizedMessage:(NSString *)localizedMessageKey {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localizedMessageKey bdk_localizedString]
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showQueryWithLocalizedMessage:(NSString *)localizedMessageKey delegate:(id<UIAlertViewDelegate>)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[localizedMessageKey bdk_localizedString]
                                                    message:nil
                                                   delegate:delegate
                                          cancelButtonTitle:[@"Cancel" bdk_localizedString]
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showError:(NSError *)error withCodeDescription:(const char *)codeDescription lineNumber:(int)lineNumber {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error (%ld)", (long)error.code]
                                                    message:[NSString stringWithFormat:@"%@%@%s\n(Line %d)",
                                                             (error.localizedDescription.length > 0 || error.code != BDKErrorCodeSDKInternal) ? [NSString stringWithFormat:@"%@\n\n", error.localizedDescription] : @"",
                                                             error.localizedFailureReason ? [NSString stringWithFormat:@"%@\n\n", error.localizedFailureReason] : @"",
                                                             codeDescription, lineNumber]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showAccessToken:(NSString *)accessToken {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Access Token" bdk_localizedString]
                                                    message:accessToken
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showProfile:(BDKProfile *)profile {
    NSString *profileDescription = [[NSString alloc] initWithFormat:@"[User Key]\n"
                                    "%@\n\n"
                                    "%@: %@\n"
                                    "%@: %@",
                                    profile.userKey,
                                    [@"alert.profile.isConnected" bdk_localizedString], profile.isAppConnected ? @"YES" : @"NO",
                                    [@"alert.profile.allowsMessages" bdk_localizedString], profile.allowsMessages ? @"YES" : @"NO"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:profile.name
                                                    message:profileDescription
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    [UIImage bdk_loadImageWithURL:[profile profileImageURLWithType:BDKProfileImageTypeSquare150] defaultImage:nil size:CGSizeZero completion:^(UIImage *image) {
        if (image) {
            UIImageView *profileImageView = [[UIImageView alloc] initWithImage:image];
            [profileImageView setContentMode:UIViewContentModeScaleAspectFit];
            [alert setValue:profileImageView forKey:@"accessoryView"];
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showQuotas:(NSDictionary *)quotas {
    BDKQuota *postQuota = quotas[BDKQuotaNamePost];
    BDKQuota *messageQuota = quotas[BDKQuotaNameMessage];
    BDKQuota *invitationQuota = quotas[BDKQuotaNameInvitation];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *quotaDescription = [NSString stringWithFormat:@"%@: %lu / %lu\n"
                                  "(%@)\n\n"
                                  "%@: %lu / %lu\n"
                                  "(%@)\n\n"
                                  "%@: %lu / %lu\n"
                                  "(%@)",
                                  [@"alert.quotas.postQuota" bdk_localizedString], (unsigned long)postQuota.remained, (unsigned long)postQuota.total,
                                  [NSString stringWithFormat:[@"alert.quotas.expiredAt" bdk_localizedString], [dateFormatter stringFromDate:postQuota.expirationDate]],
                                  [@"alert.quotas.messageQuota" bdk_localizedString], (unsigned long)messageQuota.remained, (unsigned long)messageQuota.total,
                                  [NSString stringWithFormat:[@"alert.quotas.expiredAt" bdk_localizedString], [dateFormatter stringFromDate:messageQuota.expirationDate]],
                                  [@"alert.quotas.invitationQuota" bdk_localizedString], (unsigned long)invitationQuota.remained, (unsigned long)invitationQuota.total,
                                  [NSString stringWithFormat:[@"alert.quotas.expiredAt" bdk_localizedString], [dateFormatter stringFromDate:invitationQuota.expirationDate]]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Quotas" bdk_localizedString]
                                                    message:quotaDescription
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showGuildBandNameInputAlertWithCompletion:(void (^)(NSString *bandName))completion {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"topMenu.menu.createGuildBand" bdk_localizedString]
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:[@"Cancel" bdk_localizedString]
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField *bandNameField = [alert textFieldAtIndex:0];
    [bandNameField setPlaceholder:[@"band.option.searching.field.placeholder" bdk_localizedString]];
    
    BDKInputAlertViewDelegateImpl *impl = [BDKInputAlertViewDelegateImpl sharedInstance];
    [impl setInputField:bandNameField];
    [impl setCompletion:completion];
    [alert setDelegate:impl];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showBand:(BDKBand *)band {
    NSString *bandDescription = [[NSString alloc] initWithFormat:@"[Band Key]\n"
                                 "%@\n\n"
                                 "%@"
                                 "%@: %@",
                                 band.bandKey,
                                 band.memberCount ? [[NSString alloc] initWithFormat:@"%@: %@\n", [@"Member Count" bdk_localizedString], band.memberCount] : @"",
                                 [@"alert.band.isGuildBand" bdk_localizedString], band.isGuildBand ? @"YES" : @"NO"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:band.name
                                                    message:bandDescription
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    
    [UIImage bdk_loadImageWithURL:[band coverImageURLWithType:BDKBandCoverImageTypeAspectFill312] defaultImage:nil size:CGSizeZero completion:^(UIImage *image) {
        if (image) {
            UIImageView *profileImageView = [[UIImageView alloc] initWithImage:image];
            [profileImageView setContentMode:UIViewContentModeScaleAspectFit];
            [alert setValue:profileImageView forKey:@"accessoryView"];
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showOfficialBandInformationWithBandKey:(NSString *)bandKey joined:(BOOL)joined {
    NSString *officialBandDescription = [[NSString alloc] initWithFormat:@"[Band Key]\n"
                                         "%@\n\n"
                                         "%@: %@",
                                         bandKey,
                                         [@"alert.officialBand.isJoined" bdk_localizedString], joined ? @"YES" : @"NO"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Official Band" bdk_localizedString]
                                                    message:officialBandDescription
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showPost:(BDKPost *)post {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *postDescription = [[NSString alloc] initWithFormat:@"%@\n\n"
                                 "%@: %@\n"
                                 "%@: %@\n"
                                 "%@: %@\n",
                                 post.content,
                                 [@"Author" bdk_localizedString], post.author.name,
                                 [@"alert.post.date" bdk_localizedString], [dateFormatter stringFromDate:post.createdAt],
                                 [@"alert.post.commentCount" bdk_localizedString], post.commentCount];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[NSString alloc] initWithFormat:@"Post Key:\n%@", post.postKey]
                                                    message:postDescription
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    
    if (post.photos.count > 0) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(alert.bounds), 150.0f)];
        [alert setValue:scrollView forKey:@"accessoryView"];
        
        for (BDKPostPhoto *photo in post.photos) {
            CGFloat adjustedWidth;
            CGFloat adjustedHeight;
            __block NSUInteger imageLoadingCount = 0;
            
            if (photo.size.width > photo.size.height) {
                adjustedWidth = 150.0f;
                adjustedHeight = 150.0f * photo.size.height / photo.size.width;
            } else {
                adjustedWidth = 150.0f * photo.size.width / photo.size.height;
                adjustedHeight = 150.0f;
            }
            
            [UIImage bdk_loadImageWithURL:photo.URL defaultImage:nil size:CGSizeMake(adjustedWidth, adjustedHeight) completion:^(UIImage *image) {
                imageLoadingCount++;
                
                if (image) {
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    
                    CGRect frame = imageView.frame;
                    frame.origin.x = scrollView.contentSize.width;
                    [imageView setFrame:frame];
                    
                    [scrollView addSubview:imageView];
                    [scrollView setContentSize:CGSizeMake(CGRectGetMaxX(frame) + ([photo isEqual:post.photos.lastObject] ? 0.0f : 1.0f), scrollView.contentSize.height)];
                }
            }];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}


+ (void)bdk_showResultWithTitle:(NSString *)title quota:(BDKQuota *)quota {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *quotaDescription = [NSString stringWithFormat:@"[%@]\n"
                                  "%lu / %lu\n"
                                  "(%@)",
                                  [@"Quota" bdk_localizedString],
                                  (unsigned long)quota.remained, (unsigned long)quota.total,
                                  [NSString stringWithFormat:[@"alert.quotas.expiredAt" bdk_localizedString], [dateFormatter stringFromDate:quota.expirationDate]]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:quotaDescription
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:[@"OK" bdk_localizedString], nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

@end


#pragma mark -

@implementation BDKInputAlertViewDelegateImpl

#pragma mark - Instantiation

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    __strong static BDKInputAlertViewDelegateImpl *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            BDK_RUN_BLOCK(self.completion, self.inputField.text);
            break;
        default:
            break;
    }
}

@end
