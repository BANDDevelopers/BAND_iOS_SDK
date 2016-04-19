//
//  BDKBandJoinViewController.h
//  BDK Sample
//
//  Created by Alan on 2016. 2. 27..
//  Copyright © 2016년 Camp Mobile Inc. All rights reserved.
//


#import <UIKit/UIKit.h>


@class BDKBand;


@interface BDKBandJoinViewController : UIViewController

+ (instancetype)bandJoinViewControllerWithBand:(BDKBand *)band completion:(void (^)(BDKBand *joinedBand))completion;

@end
