//
//  BDKMemberViewController.h
//  BDK Sample
//
//  Created by Alan on 2016. 2. 4..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@class BDKProfile, BDKBand;


@interface BDKMemberViewController : UIViewController

@property (strong, nonatomic) NSString *titleSeed;

@property (assign, nonatomic) BOOL allowsConnectedMembersOnly;
@property (assign, nonatomic) BOOL allowsDisplaySelf;
@property (assign, nonatomic) BOOL allowsNotConnectedMembersOnly;
@property (assign, nonatomic) BOOL allowsSendMessagesOrInvite;

@property (copy, nonatomic) void (^selectionCompletion)(BDKMemberViewController *viewController, BDKProfile *profile);


+ (instancetype)memberViewControllerWithBand:(BDKBand *)band;

@end
