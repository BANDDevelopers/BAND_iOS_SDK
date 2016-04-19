//
//  BDKBandViewController.h
//  BDK Sample
//
//  Created by Alan on 2016. 2. 16..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@class BDKBand;


@interface BDKBandViewController : UIViewController

@property (strong, nonatomic) NSString *titleSeed;

@property (assign, nonatomic) BOOL allowsGuildBandOnly;
@property (assign, nonatomic) BOOL allowsJoinableGuildBandOnly;

@property (copy, nonatomic) void (^selectionCompletion)(BDKBandViewController *viewController, BDKBand *band);

           
+ (instancetype)bandViewController;

@end
