//
//  BDKPostListViewController.h
//  BDK Sample
//
//  Created by Alan on 2016. 3. 2..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@class BDKBand, BDKPost;


@interface BDKPostListViewController : UIViewController

@property (copy, nonatomic) void (^selectionCompletion)(BDKPostListViewController *postListViewController, BDKPost *post);


+ (instancetype)officialBandPostListViewController;
+ (instancetype)officialBandNoticeListViewController;
+ (instancetype)guildBandPostListViewControllerWithBand:(BDKBand *)band;
+ (instancetype)guildBandNoticeListViewControllerWithBand:(BDKBand *)band;

@end
